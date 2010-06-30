# -*- coding: utf-8 -*-

require 'rss'

class FeedsController < ApplicationController
  # caches_page :show

  def show
    blogs = Blog.find(:all, :order => "created_at DESC", :limit => 15)
    if blogs.empty?
      render :text => "Page not found", :status => :not_found
      return
    end
    @recent = recent_blog(blogs)
    respond_to do |format|
      format.rdf {render(:text => make_feed("rss1.0", "rdf", @recent))}
      format.rss {render(:text => make_feed("rss2.0", "rss", @recent))}
      format.atom {render(:text => make_feed("atom", "atom", @recent))}
    end
  end

  private
  def make_feed(version, format, recent)
    sanitizer = Object.new
    class << sanitizer
      include ActionView::Helpers::SanitizeHelper::ClassMethods
      def strip_tags(html)
        full_sanitizer.sanitize(html)
      end
    end

    RSS::Maker.make(version) do |maker|
      channel = maker.channel
      channel.title = "たいやきる？ - たいやき部"
      channel.about = feed_url(:format => format)
      channel.link = root_url
      channel.description = "たいやきとあんなことやこんなことを"
      channel.language = "ja"
      channel.author = "たいやき部"
      channel.generator do |generator|
        generator.content = "Tiyaking"
        generator.uri = "http://github.com/taiyaki/taiyaking/tree"
      end
      channel.date = recent[0][:date].time

      recent.each do |item|
        maker.items.new_item do |feed_item|
          feed_item.title = item[:title]
          feed_item.description = sanitizer.strip_tags(item[:content])
          feed_item.content_encoded = item[:content]
          feed_item.content.type = "xhtml"
          feed_item.content.xml_content = item[:content]
          feed_item.link = item[:link]
          feed_item.guid.isPermaLink = false
          feed_item.guid.content = item[:link]
          feed_item.date = item[:date].time
          feed_item.dc_creators.new_creator do |creator|
            creator.content = item[:author]
          end
        end
      end
    end
  end
end
