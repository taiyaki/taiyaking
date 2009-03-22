require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Shop do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :address => "value for address",
      :tel => "value for tel"
    }
  end

  it "should create a new instance given valid attributes" do
    Shop.create!(@valid_attributes)
  end
end
