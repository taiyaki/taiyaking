# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ApplicationHelper

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '69358521fb1bd90470318198f05f3855'

  before_filter :set_return_path

  private
  def set_return_path
    if request.get? and set_return_path?
      session[:user_return_to] = request.url
    end
  end

  def set_return_path?
    true
  end

  def after_sign_out_path_for(resource_or_scope)
    session[:user_return_to] || super
  end
end
