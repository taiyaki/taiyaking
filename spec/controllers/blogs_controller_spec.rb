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
    before do
      session[:user_id] = nil
      get :new
    end
    it "フロントにリダイレクトする" do
      response.should redirect_to(:controller => 'front', :action => 'index')
    end
  end

  describe "ブログindexにアクセスすると" do
    before do
      session[:user_id] = users(:tanaka).id
      get :index
    end
    it "ブログ一覧が表示される" do
      response.should be_success
    end
  end
  
  describe "ログインしてブログ記事を投稿すると" do
    before do
      user_login
      @blog = mock_model(Blog, :title => "blog title", :user_id => users(:tanaka).id, :entry => "blog content", :slug => "perm_link")
      Blog.stub!(:new).and_return(@blog)
      @blog.stub!(:user=).and_return(users(:tanaka))
    end

    describe "記事を保存できる場合" do
      before do
        @blog.should_receive(:save).and_return(true)
        post :create
      end
      it { response.should redirect_to(:controller => "blogs", :action => "show", :id => @blog.id) }
    end
    describe "記事を保存できない場合" do
      before do
        @blog.should_receive(:save).and_return(false)
        post :create
      end
      it { response.should render_template("blogs/new") }
    end
  end
end
