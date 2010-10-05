require 'rubygems'
require 'machinist'
require 'machinist/blueprints'
require 'active_resource'

module Machinist
  
  class ActiveResourceAdapter
    
    def self.has_association?(object, attribute)
      false 
    end
    
    #def self.class_for_association(object, attribute)
      #association = object.class.reflect_on_association(attribute)
      #association && association.klass
    #end
    
    # This method takes care of converting any associated objects,
    # in the hash returned by Lathe#assigned_attributes, into their
    # object ids.
    #
    # For example, let's say we have blueprints like this:
    #
    #   Post.blueprint { }
    #   Comment.blueprint { post }
    #
    # Lathe#assigned_attributes will return { :post => ... }, but
    # we want to pass { :post_id => 1 } to a controller.
    #
    # This method takes care of cleaning this up.
    def self.assigned_attributes_without_associations(lathe)
      attributes = {}
      lathe.assigned_attributes.each_pair do |attribute, value|
        attributes[attribute] = value
      end
      attributes
    end
    
  end
    
  module ActiveResourceExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def make(*args, &block)
        lathe = Lathe.run(Machinist::ActiveResourceAdapter, self.new, *args)
        # What is Nerfed ?
        #unless Machinist.nerfed?
          #lathe.object.save!
          #lathe.object.reload
        #end
        lathe.object(&block)
      end

      def make_unsaved(*args)
        object = Machinist.with_save_nerfed { make(*args) }
        yield object if block_given?
        object
      end
        
      def plan(*args)
        lathe = Lathe.run(Machinist::ActiveResourceAdapter, self.new, *args)
        Machinist::ActiveResourceAdapter.assigned_attributes_without_associations(lathe)
      end
    end
  end
end

class ActiveResource::Base
  include Machinist::Blueprints
  include Machinist::ActiveResourceExtensions
end
