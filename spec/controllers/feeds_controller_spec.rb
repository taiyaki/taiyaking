require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeedsController do
  fixtures :blogs, :users

  #Delete these examples and add some real ones
  it "should use FeedsController" do
    controller.should be_an_instance_of(FeedsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should be correct timezone" do
      get 'index'
      items = RSS::Parser.parse(response.body).items
      expected = [
                  Time.parse("2009-04-07T20:10:30+00:00").utc,
                  Time.parse("2009-04-01T00:11:22+00:00").utc,
                 ]
      items.collect(&:dc_date).should == expected
    end

    it "should return NOT FOUND when no post exist" do
      Blog.destroy_all
      get 'index'
      response.should be_not_found
    end
  end
end
