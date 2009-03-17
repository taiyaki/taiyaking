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
      response.should redirect_to(login_path)
    end
  end

  describe "newが呼ばれたら" do
    before do
      get :new
    end

    it "飛び先をセッションに格納する" do
      session[:jumpto] == root_path
    end
    it "ログインフォームを表示する" do
      response.should be_success
    end
  end

  describe "openid_url入力無しでcreateが呼ばれたら" do
    before do
      request.env['HTTP_REFERER'] = @back = "http://test.host/"
      post :create
    end

    it "前のページにリダイレクトする" do
      response.should redirect_to :back
    end
  end

  describe "openid_url入力ありでcreateが呼ばれたら" do
    before do
      session[:jumpto] = login_path
      controller.stub!(:using_open_id?).and_return(true)
      result = mock("result", :status => :successful)
      controller.stub!(:authenticate_with_open_id).and_yield(result, "http://test.host", "hoge")
    end

    describe "以前にログインしたユーザーなら" do
      before do
        @user = mock_model(User, :claimed_url => "http://test.host/")
        User.stub!(:find_by_claimed_url).and_return(@user)
        post :create, :openid_identifier => "http://test.host/"
      end

      it "元のページにリダイレクトする" do
        response.should redirect_to login_path
      end
    end

    describe "はじめてログインするユーザーなら" do
      before do
        User.stub!(:find_by_claimed_url).and_return(nil)
        post :create, :openid_identifier => "http://test.host/"
      end
      it "ユーザーを作り元のページにリダイレクトする" do
        response.should redirect_to login_path
      end
    end
  end

  describe "openid_url入力ありでcreateが呼ばれ認証失敗したら" do
    before do
      controller.stub!(:using_open_id?).and_return(true)
      result = mock("result", :status => :failed)
      controller.stub!(:authenticate_with_open_id).and_yield(result, "http://test.host", "hoge")
      post :create, :openid_identifier => "http://test.host/"
    end

    it "ログインページにリダイレクトする" do
      response.should redirect_to login_path
    end
  end
end

