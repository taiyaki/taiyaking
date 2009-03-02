class SessionsController < ApplicationController
  @@default_page = '/'
  
  @@required = {
    :nickname => "nickname",
    :email => "email"
  }

  @@optional = {
    :fullname => "fullname",
    :birth_day => "dob",
    :gender => "gender",
    :postcode => "postcode",
    :country => "country",
    :language => "language",
    :timezone => "timezone"
  }

  def new
    #redirect_to default_page
    session[:jumpto] = request.referer || "/"
  end

  def create
    if using_open_id?
      open_id_authentication
    else
      flash[:error] = "You must provide an OpenID URL"
      redirect_to tyied_page
    end
  end

  def destroy
    reset_session
    redirect_to default_page
  end

  private
  def open_id_authentication
    options = {
      :required => @@required.values.map {|str| str.to_sym},
      :optional => @@optional.values.map {|str| str.to_sym},
      :target_column => "endpoint_url"
    }
    authenticate_with_open_id(params[:openid_url], options) do |result, identity_url, registration|
      p result
      case result.status
      when :found_in_whitelist_or_blacklist
        failed_login "Sorry, the OpenID server is blocked by the white list"
      when :double_auth
        failed_login "Error, detect a double autentication"
      when :missing
        failed_login "Sorry, the OpenID server couldn't be found"
      when :canceled
        failed_login "OpenID verification was canceled"
      when :failed
        failed_login "Sorry, the OpenID verification failed"
      when :successful
        if @current_user = User.find_by_claimed_url(identity_url)
          successful_login
        else
          @current_user = User.new
          assign_registration_attributes!(registration)
          @current_user.claimed_url = identity_url
          @current_user.nickname = identity_url.delete("http://")[0..8] if @current_user.nickname.blank?
          if @current_user.save
            successful_login
          else
            failed_login "Your OpenID profile registration failed: " +
              @current_user.errors.full_messages.to_sentence
          end
        end
      end
    end
  end

  def successful_login
    session[:user_id] = @current_user.id
    jumpto = session[:jumpto] || default_page
    session[:jumpto] = nil
    redirect_to(jumpto)
    #redirect_to(root_url)
  end

  def failed_login
    flash[:error] = message
    redirect_to default_page
  end

  def default_page
    @@default_page
  end

  def tyied_page
    request.referer
  end

  def assign_registration_attributes!(registration)
    model_to_registration_mapping.each do |model_attribute, registration_attribute|
      unless registration[registration_attribute].blank?
        @current_user.send("#{model_attribute}=", registration[registration_attribute])
      end
    end
  end

  def model_to_registration_mapping
    @@required.merge(@@optional)
  end
end
