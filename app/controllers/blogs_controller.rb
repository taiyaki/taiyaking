# -*- coding: utf-8 -*-

class BlogsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :wordpress_link]
  before_filter :find_blog, :only => [:show, :edit, :update, :destory]
  cache_sweeper :blog_sweeper, :only => [:create, :update, :destroy]

  def index
    @blogs = Blog.order("created_at DESC").page(params[:page])
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
    @title = @blog.title.force_encoding("utf-8")
    @previous_blog = Blog.find_by_id(@blog.id - 1)
    @next_blog = Blog.find_by_id(@blog.id + 1)
  end

  def wordpress_link
    redirect_to blog_path(:id => params[:slug])
  end

  def edit
    @blog.user = logined_user
    @title = "エントリ編集"
 end

  def update
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
    @blog.destroy
    flash[:notice] = "#{@blog.title}を削除しました"
    redirect_to :action => :index
  end

  private
  def find_blog
    id = params[:id]
    if /\A\d+\z/ =~ id
      @blog = Blog.find(id)
    else
      @blog = Blog.find_by_slug(id)
      if @blog.nil?
        raise ActiveRecord::RecordNotFound,
              "Couldn't find Blog with slug=#{id.inspect}"
      end
    end
  end
end
