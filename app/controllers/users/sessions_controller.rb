class Users::SessionsController < Devise::SessionsController
  private
  def set_return_path?
    false
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    super
    cookies[:nickname] = current_user.nickname
  end

  def sign_out_and_redirect(resource_or_scope)
    super
    cookies.delete(:nickname)
  end
end
