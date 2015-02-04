# Gère les commentaires, réponses d'un sujet. Un sujet fait lui-même parti d'un groupe
class Group::CommentsController < ApplicationController
  before_action :get_required_objects # instancie le sujet et le groupe auquel appartient le commentaire
  before_action :get_comment, only: [:edit, :update, :destroy]

  # Créé un nouveau commentaire pour un sujet
  # POST /groups/:group_group_id/topics/:id
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

  # GET /groups/:group_group_id/topics/:topic_id/comments/:id/edit
  def edit
  end

  # PATCH /groups/:group_group_id/topics/:topic_id/comments/:id
  def update
    if @comment.update(message: params[:group_comment][:message])
      redirect_to group_group_topic_path(group_group_id: @group, id: @topic, anchor: @comment.id), notice: t('groups.comments.notices.comment_updated')
    else
      render :edit
    end
  end

  # DELETE /groups/:group_group_id/topics/:topic_id/comments/:id
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