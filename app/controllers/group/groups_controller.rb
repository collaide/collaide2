class Group::GroupsController < ApplicationController

  def create
    User.new
    @group = Group::Group.new(name: group_params[:name], user: current_user)
    if @group.save
      redirect_to group_group_path(@group)
    else
      render :new
    end
  end

  def new
    @group = Group::Group.new
  end

  def show
    @group = Group::Group.find params[:id]
  end

  private

  def group_params
    params.require(:group_group).permit(:name)
  end
end