class Group::CommentsController < ApplicationController
  before_action :get_required_objects
  before_action :get_comment, only: [:edit, :update, :destroy]

  def create
    @comment = Group::Comment.new(comment_params)
    @comment.user = current_user
    @comment.topic = @topic
    if @comment.save
      redirect_to group_group_topic_path(group_group_id: @group, id: @topic, anchor: @comment.id), notice: t('groups.comments.notices.comment_created')
    else
      render 'group/comments/new'
    end
  end

  def edit

  end

  def update
    if @comment.update(message: params[:group_comment][:message])
      redirect_to group_group_topic_path(group_group_id: @group, id: @topic, anchor: @comment.id), notice: t('groups.comments.notices.comment_updated')
    else
      render :edit
    end
  end

  def destroy
    @comment.delete
    redirect_to group_group_topic_path(group_group_id: @group, id: @topic), notice: t('groups.comments.notices.comment_deleted')
  end

  private

  def get_required_objects
    @group = Group::Group.find params[:group_group_id]
    @topic = @group.topics.where(id: params[:topic_id]).take!
  end

  def get_comment
    @comment = @topic.comments.where(id: params[:id]).take!
  end

  def comment_params
    params.require(:group_comment).permit(:message)
  end
end