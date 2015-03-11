class Group::TopicsController < ApplicationController
  include Concerns::ActivityConcern
  before_action :get_required_objects
  before_action :find_topic, only: [:update, :edit, :show]

  # GET /groups/:group_group_id/topics
  def index
    authorize @group
    @topic = Group::Topic.new # Pour le formulaire
    @topics = @group.topics.order('group_topics.updated_at DESC, group_topics.created_at DESC, group_topics.views DESC').includes({comments: :user}, :user).page(params[:page])
  end

  # POST /groups/:group_group_id/topics
  def create
    authorize @group
    @topic = Group::Topic.new(topic_params)
    @topic.user = current_user
    @topic.group = @group
    if @topic.save
      create_group_activity :new_topic, :addition, recipient: @topic
      redirect_to group_group_topic_path(group_group_id: @group, id: @topic), notice: t('groups.topics.create.success')
    else
      render :new
    end
  end

  def update
    authorize @group, @topic
    if @topic.update(topic_params)
      create_group_activity :topic_updated, :info, recipient: @topic
      redirect_to group_group_topic_path(group_group_id: @group, id: @topic)
    else
      render :edit
    end
  end

  def edit
    authorize @group, @topic
  end

  def new
    authorize @group
    @topic = Group::Topic.new
  end

  def show
    authorize @group
    @comments = Group::Comment.includes(:user).where(topic_id: @topic)

    render :show
    @topic.update_view
  end

  def destroy
    create_group_activity :topic_deleted, :deletion
    topic = @group.topics.where(id: params[:id]).take
    authorize @group, topic
    comments = topic.comments
    comments.each { |comment| comment.destroy }
    topic.delete
    redirect_to group_group_topics_path, notice: t('groups.topics.notice.deleted', topic: topic)
  end

  private

  def find_topic
    @topic = @group.topics.where(id: params[:id]).take!
  end

  def topic_params
    params.require(:group_topic).permit(:title, :message)
  end

  def get_required_objects
    @comment = Group::Comment.new
    @group = Group::Group.find(params[:group_group_id])
  end
end