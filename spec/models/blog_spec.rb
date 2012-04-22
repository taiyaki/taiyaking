# -*- coding: utf-8 -*-

require 'spec_helper'

describe Blog do
  fixtures :blogs, :users

  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :entry => "value for entry",
      :slug => "value_for_slug"
    }
  end

  it "should create a new instance given valid attributes" do
    users(:tanaka).blogs.create!(@valid_attributes)
  end

  it "blogエントリー作成者を参照できる" do
    Blog.find(blogs(:one).id).user.nickname.should == "MyString"
  end

end
