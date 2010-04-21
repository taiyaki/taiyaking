# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ApplicationHelper

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '69358521fb1bd90470318198f05f3855'

  private
  def block_until_authorized
    return if login?
    flash[:notice] = "Please login"
    source = request.referer || root_path
    redirect_to(source)
  end

#   def got_through_authorized
#     return if login?
#     flash[:notice] = "Please login"
#     session[:jumpto] = request.parameters
#     redirect_to(login_path)
#   end

end
