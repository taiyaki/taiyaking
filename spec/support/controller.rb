module UserControllerExampleMethods
  def user_login
    session[:user_id] = users(:tanaka).id
  end
end
