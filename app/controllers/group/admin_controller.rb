class Group::AdminController < ApplicationController

  def index
    authorize
    @group = Group::Group.find params[:group_group_id]
    @member = @group.get_member current_user
  end
end