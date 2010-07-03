# -*- coding: utf-8 -*-

require 'spec_helper'

describe BlogsController do
  fixtures :blogs, :users

  describe "ログインしてnewにアクセスすると" do
    before(:each) do
      user_login
      get :new
    end
    it "ブログ新規エントリが表示される" do
      response.should be_success
    end
  end

  describe "ログインしないで" do
    before do
      session[:user_id] = nil
    end

    describe "newにアクセスすると" do
      before do
        get :new
      end
      it "フロントにリダイレクトする" do
        response.should redirect_to(root_path)
      end
    end

    describe "wordpress_linkにアクセスすると" do
      before do
        get :wordpress_link, :slug => "permlink"
      end
      it "permlinkにリダイレクトする" do
        response.should redirect_to(permlink_blog_path(:slug => "permlink"))
      end
    end
  end

  describe "ブログindexにアクセスすると" do
    before do
      user_login
      get :index
    end
    it "ブログ一覧が表示される" do
      response.should be_success
    end
  end
  
  describe "ログインして" do
    before do
      user_login
      @blog = mock_model(Blog, :title => "blog title", :user_id => users(:tanaka).id, :entry => "blog content", :slug => "perm_link")
      Blog.stub!(:new).and_return(@blog)
      @blog.stub!(:user=).and_return(users(:tanaka))
    end

    describe "createで新規記事を保存できる" do
      before do
        @blog.should_receive(:save).and_return(true)
        post :create
      end
      it { response.should redirect_to(:controller => "blogs", :action => "show", :id => @blog.id) }
    end
    describe "createで新規記事を保存できない" do
      before do
        @blog.should_receive(:save).and_return(false)
        post :create
      end
      it { response.should render_template("blogs/new") }
    end

    describe "editで既存記事を編集できる" do
      before do
        Blog.stub!(:find).and_return(@blog)
        get :edit, :id => @blog.id
      end
      it { response.should be_success }
    end

    describe "updateで既存記事を更新できる" do
      before do
        Blog.stub!(:find).and_return(@blog)
        @blog.stub!(:attributes=).and_return(nil)
        @blog.stub!(:user=).and_return(users(:tanaka))
        @blog.stub!(:save).and_return(true)
        post :update, :id => @blog.id
      end
      it { response.should redirect_to :action => "show", :id => @blog.id }
    end

    describe "updateで既存記事を更新できない" do
      before do
        Blog.stub!(:find).and_return(@blog)
        @blog.stub!(:attributes=).and_return(nil)
        @blog.stub!(:user=).and_return(users(:tanaka))
        @blog.stub!(:save).and_return(false)
        post :update, :id => @blog.id
      end
      it { response.should render_template "blogs/edit" }
    end

    describe "destroyで記事を削除できる" do
      before do
        Blog.stub!(:find).and_return(@blog)
        @blog.stub!(:destroy).and_return(@blog)
        post :destroy, :id => @blog.id
      end
      it { response.should redirect_to :action => "index" }
    end
  end

  describe "showにアクセスすると" do
    describe "ブログ1件表示される" do
      before do
        get :show, :id => blogs(:one).id
      end
      it { response.should be_success }
    end

    describe "指定されたブログが無い場合" do
      before do
        get :show, :id => 0
      end
      it { response.code.should == '404' }
    end
  end
end
