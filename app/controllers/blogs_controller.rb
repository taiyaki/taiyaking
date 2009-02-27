class BlogsController < ApplicationController
  before_filter :block_until_authorized,
    :only => [:new, :edit, :create, :update, :destory]

  def index
    @blogs = Blog.find(:all, :order => "updated_at DESC", :limit => 5)
  end

  def new
    @blog = Blog.new
    @blog.user = logined_user
  end

  def create
    blog = Blog.new(params[:blog])
    blog.user = logined_user
    blog.save
    redirect_to :action => 'show', :id => blog.id
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def edit
    @blog = Blog.find(params[:id])
    @blog.user = logined_user
  end

  def update
    blog = Blog.find(params[:id])
    blog.attributes = params[:blog]
    blog.user = logined_user
    if blog.save
      flash[:notice] = '更新しました'
      redirect_to :action => 'show', :id => blog.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    blog = Blog.find(params[:id])
    blog.destroy
    flash[:notice] = "#{blog.title}を削除しました"
    redirect_to :action => :index
  end
end
