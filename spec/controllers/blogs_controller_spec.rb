require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BlogsController do
  fixtures :blogs, :users

  describe "ログインしてnewにアクセスすると" do
    before(:each) do
      session[:user_id] = users(:tanaka).id
      get :new
    end
    it "ブログ新規エントリが表示される" do
      response.should be_success
    end
  end

  describe "ログインしないでnewにアクセスすると" do
    before(:each) do
      session[:user_id] = nil
      get :new
    end
    it "フロントにリダイレクトする" do
      # FIXME: know bug Rspec 1.1.12
      # http://github.com/dchelimsky/rspec-rails/commit/398e19cb5b90aa153ffe7953601e7e90987a0103
      #response.should redirect_to(:controller => 'front', :action => 'index')
    end
  end

end
