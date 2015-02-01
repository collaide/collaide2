class Group::CommentsController < ApplicationController
  before_action :get_required_objects

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