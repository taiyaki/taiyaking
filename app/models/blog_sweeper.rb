class BlogSweeper < ActionController::Caching::Sweeper
  observe Blog

  def after_save(record)
    expire_page(:controller => "front", :action => "index")
    expire_page(:controller => "feed", :action => "index")
  end
end
