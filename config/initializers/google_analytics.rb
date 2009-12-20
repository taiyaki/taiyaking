google_analytics_code = RAILS_ROOT + "config" + "google-analytics-code.txt"
if File.exist?(google_analytics_code)
  GOOGLE_ANALYTICS_CODE = File.read(google_analytics_code)
end
