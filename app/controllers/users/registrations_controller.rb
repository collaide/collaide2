#pour devise. Permet de rajouter des attributs personalisés et d'éviter le un permitted attributes error
class Users::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  def update_resource(resource, params)
    if params[:password].blank? and params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  def new
    redirect_to new_user_session_path
  end

  def edit
    view = params[:view]
    if view == 'general' or view == 'password'
      super
    else
      redirect_to edit_user_registration_path(view: :general)
    end
  end

  # # PUT /resource
  # # We need to use a copy of the resource because we don't want to change
  # # the current user in place.
  # def update
  #   self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  #   prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
  #
  #   resource_updated = update_resource(resource, account_update_params)
  #   yield resource if block_given?
  #   if resource_updated
  #     if is_flashing_format?
  #       flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
  #           :update_needs_confirmation : :updated
  #       set_flash_message :notice, flash_key
  #     end
  #     sign_in resource_name, resource, bypass: true
  #     respond_with resource, location: after_update_path_for(resource)
  #   else
  #     clean_up_passwords resource
  #     respond_with resource
  #   end
  # end

  protected

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name,
               :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :avatar,
               :email, :password, :password_confirmation, :current_password)
    end
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

end