require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Application < ActiveResource::Base
  self.site = 'http://test.local'
end


describe "ActiveResource adapter" do
   before(:each) do
      Application.clear_blueprints!
      Application.blueprint do
         name "My Application"
         email "my@email.com"
       end
    end

   describe '#make' do
     context 'When use default values' do
       subject { Application.make }

       its(:name)  { should == "My Application" }
       its(:email) { should == "my@email.com" }
     end

     context 'When change one value' do
       subject { Application.make(:name => "Another Application") }

       its(:name)  { should == "Another Application" }
       its(:email) { should == "my@email.com" }
     end
   end


   describe '#plan' do
     context 'When use default values' do
       subject { Application.plan }

       it { subject[:name].should  == "My Application"}
       it { subject[:email].should == "my@email.com"}
     end

     context 'When change one value' do
       subject { Application.plan(:email => "other@email.com") }

       it { subject[:name].should  == "My Application"}
       it { subject[:email].should == "other@email.com"}
     end
   end
end
