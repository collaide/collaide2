# Gère les commentaires, réponses d'un sujet. Un sujet fait lui-même parti d'un groupe
class Group::CommentsController < ApplicationController
  include Concerns::ActivityConcern
  before_action :get_required_objects # instancie le sujet et le groupe auquel appartient le commentaire
  before_action :get_comment, only: [:edit, :update, :destroy]

  # Créé un nouveau commentaire pour un sujet
  # POST /groups/:group_group_id/topics/:id
  def create
    authorize @group
    @comment = Group::Comment.new(comment_params)
    @comment.user = current_user
    @comment.topic = @topic
    if @comment.save
      create_group_activity :new_comment, :addition, recipient: @comment
      redirect_to group_group_topic_path(group_group_id: @group, id: @topic, anchor: @comment.id), notice: t('groups.comments.notices.comment_created')
    else
      render 'group/comments/new'
    end
  end

  # GET /groups/:group_group_id/topics/:topic_id/comments/:id/edit
  def edit
    authorize @group, @comment
  end

  # PATCH /groups/:group_group_id/topics/:topic_id/comments/:id
  def update
    authorize @group, @comment
    if @comment.update(message: params[:group_comment][:message])
      create_group_activity :update_comment, :info, recipient: @comment
      redirect_to group_group_topic_path(group_group_id: @group, id: @topic, anchor: @comment.id), notice: t('groups.comments.notices.comment_updated')
    else
      render :edit
    end
  end

  # DELETE /groups/:group_group_id/topics/:topic_id/comments/:id
  def destroy
    authorize @group, @comment
    @comment.deleted = true
    @comment.save
    create_group_activity :destroy_comment, :deletion, recipient: @comment
    redirect_to group_group_topic_path(group_group_id: @group, id: @topic, anchor: @comment.id), notice: t('groups.comments.notices.comment_deleted')
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