require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Blog do
  fixtures :blogs, :users

  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :title => "value for title",
      :entry => "value for entry",
      :slug => "value for slug"
    }
  end

  it "should create a new instance given valid attributes" do
    Blog.create!(@valid_attributes)
  end

  it "blogエントリー作成者を参照できる" do
    Blog.find(blogs(:one).id).user.nickname.should == "MyString"
  end

end
