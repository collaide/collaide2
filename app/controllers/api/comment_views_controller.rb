class Api::CommentViewsController < ApplicationController
  respond_to :json

  def create
    comment = Group::Comment.find(comment_view_params[:comment_id])
    topic = Group::Topic.find(comment_view_params[:topic_id])
    comment_view = Group::CommentView.where(topic: topic, user: current_user).first_or_initialize
    comment_view.comment = comment
    comment_view.save
    render nothing: true, status: :created
  end

  def index
    topic = Group::Topic.find(params[:topic_id])
    comment_views = Group::CommentView.where(topic: topic, user: current_user).take
    respond_with comment_views
  end

  private

  def comment_view_params
    params.require(:group_comment_views).permit(:comment_id, :topic_id)
  end
end