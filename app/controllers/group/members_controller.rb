class Group::MembersController < ApplicationController

  before_action :get_the_group

  def index
    authorize @group
    @members = @group.group_members.includes(:user).page(params[:page])
  end

  def update
    authorize @group
    get_member
    if @member.update(member_params)
      redirect_to group_group_admin_index_path(@group), notice: t('groups.members.update.notice')
    else
      render 'group/admin/index'
    end
  end

  private
  def get_the_group
    @group = Group::Group.find params[:group_group_id]
  end

  def get_member
    @member = @group.group_members.where(id: params[:id]).take!
  end

  def member_params
    params.require(:group_group_member).permit(:sent_notification)
  end
end