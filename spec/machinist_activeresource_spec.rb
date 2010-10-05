require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MachinistActiveresource" do
  it 'should test' do
    Application.respond_to?(:make).should be_true
  end
end
