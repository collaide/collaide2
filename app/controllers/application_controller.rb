class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :store_location

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  # Useful for returning back to the last page and better than redirect_to :back
  def back
    return root_path unless request.env['HTTP_REFERER']
    :back
  end
  private

  def set_locale
    I18n.locale = :fr
    # uncomment this line to have multi linguale site do it to config/application.rb, too
    #I18n.locale = params[:locale] || ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/]) if Rails.env == 'development'
    #logger.info "lang set to '#{I18n.locale}'"
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if(request.fullpath.start_with? '/admin' or request.post?)
      return
    end
    if (request.fullpath != new_user_session_path &&
        request.fullpath != new_user_registration_path &&
        request.fullpath != user_password_path &&
        request.fullpath != destroy_user_session_path &&
        request.fullpath != user_registration_path &&
        !request.fullpath.start_with?(edit_user_password_path) &&
            !request.fullpath.start_with?('/users/auth/') &&
                !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end
end
