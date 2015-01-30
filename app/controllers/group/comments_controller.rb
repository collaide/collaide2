class Group::CommentsController < ApplicationController
  before_action :get_required_objects
  # include Concerns::PermissionConcern
  # def destroy
  #   group = Group::WorkGroup.find params[:work_group_id]
  #   check_permission { group.can? :delete, :topic, curent_user }
  #   topic = group.topics.where(id: params[:topic_id]).take
  #   comment = topic.comments.where(id: params[:id]).take
  #   comment.destroy
  #   redirect_to group_work_group_topic_path(group, topic)
  # end
  #
  # def edit
  #   @group = Group::WorkGroup.find(params[:work_group_id])
  #   check_permission { @group.can? :write, :topic, current_user }
  #   @topic = @group.topics.where(id: params[:topic_id]).take
  #   @comment = @topic.comments.where(id: params[:id]).take
  # end

  def create
    @comment = Group::Comment.new(comment_params)
    @comment.user = current_user
    @comment.topic = @topic
    if @comment.save
      redirect_to group_group_topic_path(group_group_id: @group, id: @topic)
    else
      render 'group/topics/show'
    end
  end

  private

  def get_required_objects
    @group = Group::Group.find params[:group_group_id]
    @topic = @group.topics.where(id: params[:topic_id]).take!
  end

  def comment_params
    params.require(:group_comment).permit(:message)
  end
end