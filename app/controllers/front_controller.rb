# -*- coding: utf-8 -*-
class FrontController < ApplicationController
  caches_page :index

  def index
    @title = "最近の活動状況 - たいやきる？"
    blogs = Blog.find(:all, :order => "updated_at DESC", :limit => 5)
    @recent = recent_blog(blogs)
  end
end
