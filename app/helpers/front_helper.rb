module FrontHelper
  def entry_link_label(entry)
    entry[:date].strftime("%Y-%m-%d") + " " + h(entry[:title])
  end
end
