require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  fixtures :blogs, :users

  describe "destroyアクションが呼ばれたら" do
    before(:each) do
      session[:user_id] = users(:tanaka).id
    end

    it "ログアウトできる" do
      delete 'destroy'
      session[:user_id].should be_nil
#      response.should redirect_to(root_path)
    end
  end
end

