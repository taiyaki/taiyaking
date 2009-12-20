google_analytics_code = Rails.root + "config" + "google-analytics-code.txt"
if google_analytics_code.exist?
  GOOGLE_ANALYTICS_CODE = File.read(google_analytics_code)
end
