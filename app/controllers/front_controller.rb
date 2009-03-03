class FrontController < ApplicationController
  def index
    @title = "最近の活動状況 - たいやきる？"
    @recent = []
    blogs = Blog.find(:all, :order => "updated_at DESC", :limit => 5)
    blogs.each do |blog|
      @recent << {
        :date => blog.updated_at,
        :title => blog.title + " - Blog",
        :link => url_for(permlink_blog_path(:slug => blog.slug)),
        :content => BlueFeather.parse(blog.entry)
      }
    end
  end
end
