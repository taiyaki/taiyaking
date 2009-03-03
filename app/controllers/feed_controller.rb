class FeedController < ApplicationController
  def index
    blogs = Blog.find(:all, :order => "updated_at DESC", :limit => 5)
    @recent = recent_blog(blogs)
    respond_to do |format|
      format.rss {
        render(:layout => false, :action => "index.rxml")
      }
    end
  end
end
