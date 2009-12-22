# -*- coding: utf-8 -*-
class FrontController < ApplicationController
  caches_page :index

  def index
    blogs = Blog.find(:all, :order => "updated_at DESC", :limit => 5)
    @recent = recent_blog(blogs)
  end
end
