class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :store_location
  before_action :current_ability

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  # Useful for returning back to the last page and better than redirect_to :back
  def back
    return root_path unless request.env['HTTP_REFERER']
    :back
  end

  # Used to know the permissions of a controller when instancied
  def permission
    @permission ||= Permission.new
  end

  protected

  # Test if an action from the current controller can be authorized
  # There exists two ways for using it:
  # - With a +before_action+
  # - Inside a method. Optionals arguments can be passed to the method. For example, a group and so on.
  # In both cases, it will test if the current action is authorized from the model Ability
  #
  # If this method is newer called, it will not be checked if a user can access this action or not
  # If this method is called, but there is no permission defined nobody will be able to access this action
  def authorize(*args)
    unless permission.authorized? params[:action].to_sym, args: args
      return if user_signed_in? and current_user.admin?
      access_denied
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, self)
  end

  private

  def set_locale
    I18n.locale = :fr
    # uncomment this line to have multi linguale site do it to config/application.rb, too
    #I18n.locale = params[:locale] || ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/]) if Rails.env == 'development'
    #logger.info "lang set to '#{I18n.locale}'"
  end

  # Deal with the redirection and flash messages when an user doesn't have the permissions
  # to view a page. Called from the method authorize
  def access_denied
    logger.debug "Access denied on #{params[:controller]}##{params[:action]} for user #{current_user.nil? ? 'nil' : current_user.id}"
    respond_to do |format|
      format.json do
        render status: 401, nothing: true
      end
      format.html do
        if user_signed_in?
          redirect_to back, alert: t('alerts.not_enough_permissions')
        elsif current_user.nil?
          redirect_to user_session_path, alert: t('alerts.access_denied')
        end
      end
    end
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
