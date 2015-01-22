class Group::GroupsCreatorController < ApplicationController

  before_action :get_group
  #before_action :redirect_to_current_steps, except: [:save_user_login]

  def user_login
    if user_signed_in?
      redirect_if_user_signed_in
    else
      @group_creation = Group::GroupCreation.new
    end
  end

  def save_user_login
    @group_creation = Group::GroupCreation.new(group_creation_params, group: @group)
    if @group_creation.save
      @group.steps = :password
      @group.group_creation = @group_creation
      @group.save
      redirect_to_steps
    else
      render :user_login
    end
  end

  def password
    if user_signed_in?
      redirect_if_user_signed_in
    else
      email = @group.group_creation.email
      if User.exists?(email: email)
        @user = User.find_by email: email
        render :user_exists
      else
        @user = User.new(email: email, name: (('a'..'z').to_a + ('A'..'Z').to_a).shuffle[0..rand(5..10)].join)
        render :unknow_user
      end
    end
  end

  def invitations
  end

  private
  def redirect_to_steps
    redirect_to eval("group_group_create_#{@group.steps}_path(group_group_id: #{@group.id})")
  end

  def redirect_to_current_steps
    if @group.finished?
      redirect_to group_group_path(@group, notice: t('groups.group_creation.notices.group_finished'))
    elsif @group.steps.to_s != params[:action]
      redirect_to_steps
    end
  end

  def get_group
    @group = Group::Group.find params[:group_group_id]
  end

  def group_creation_params
    params.require(:group_group_creation).permit(:email)
  end

  def redirect_if_user_signed_in
    @group.user = current_user
    @group.steps = :invitations
    #@group.add_members()
    @group.save
    redirect_to_steps
  end
end