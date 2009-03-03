# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def login?
    session[:user_id]
#    session[:user_id] = 1
  end

  def logined_user
    User.find(session[:user_id])
  end

  def strip_html(str)
    str.sub!(/<[^<>]*>/,"") while /<[^<>]*>/ =~ str
    str
  end

  def recent_blog(blogs)
    result = []
    blogs.each do |blog|
      link = hash_for_permlink_blog_path(:slug => blog.slug)
      link[:only_path] = false
      result << {
        :date => blog.updated_at,
        :title => blog.title + " - Blog",
        :link => url_for(link),
        :content => BlueFeather.parse(blog.entry)
      }
    end
    result
  end
end
