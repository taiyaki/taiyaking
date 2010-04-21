# -*- coding: utf-8 -*-
class BlogsController < ApplicationController
  before_filter :block_until_authorized,
    :only => [:new, :edit, :create, :update, :destory]
  cache_sweeper :blog_sweeper, :only => [:create, :update, :destroy]

  def index
    # @blogs = Blog.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 5)
    @blogs = Blog.find(:all, :order => "created_at DESC", :limit => 5)
    @title = "ブログ"
  end

  def new
    @blog = Blog.new
    @blog.user = logined_user
    @title = "エントリ作成"
  end

  def create
    @blog = Blog.new(params[:blog])
    @blog.user = logined_user
    if @blog.save
      flash[:notice] = '新しいエントリを追加しました'
      redirect_to(@blog)
    else
      render :action => "new"
    end
  end

  def show
    slug = params[:slug]
    if slug.nil? and params[:id].nil?
      slug = request.path_info.split(/\//).last
    end
    @blog = slug ? Blog.find_by_slug(slug) : Blog.find_by_id(params[:id])

    unless @blog
      render :text => "Page not found", :status => :not_found
      return
    end
    @title = @blog.title.force_encoding("utf-8")
  end

  def wordpress_link
    redirect_to permlink_blog_path(:slug => params[:slug])
  end

  def edit
    @blog = Blog.find(params[:id])
    @blog.user = logined_user
    @title = "エントリ編集"
 end

  def update
    @blog = Blog.find(params[:id])
    @blog.attributes = params[:blog]
    @blog.user = logined_user
    if @blog.save
      flash[:notice] = 'エントリを更新しました'
      redirect_to(@blog)
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
