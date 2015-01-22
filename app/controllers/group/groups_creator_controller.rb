class Group::GroupsCreatorController < ApplicationController

  before_action :get_group
  before_action :redirect_to_current_steps

  def user_login
    if user_signed_in?
      @group.user = current_user
      @group.steps = :invitations
      @group.save
      redirect_to_steps
    end
  end

  def save_user_login

  end

  def password

  end

  def invitations

  end

  private
  def redirect_to_steps
    redirect_to eval("group_group_create_#{@group.steps}_path(group_group_id: #{@group.id})")
  end

  def redirect_to_current_steps
    unless @group.steps.to_s == params[:action]
      redirect_to_steps
    end
  end

  private
  def get_group
    @group = Group::Group.find params[:group_group_id]
  end
end