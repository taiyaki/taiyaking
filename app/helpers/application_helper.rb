# -*- coding: utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def login?
    user_signed_in?
  end

  def logined_user
    current_user
  end

  def recent_blog(blogs)
    result = []
    blogs.each do |blog|
      link = hash_for_blog_path(:id => blog.slug || blog.id)
      link[:only_path] = false
      result << {
        :date => blog.updated_at,
        :title => blog.title + " - Blog",
        :link => url_for(link),
        :content => BlueFeather.parse(blog.entry),
        :author => blog.user.nickname
      }
    end
    result
  end

  def page_title
    @title ||= nil
    title = "たいやきる？たいやき部"
    if @title
      "#{h(@title)} - #{title}"
    else
      title
    end
  end
end
