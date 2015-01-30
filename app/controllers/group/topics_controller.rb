class Group::TopicsController < ApplicationController
  before_action :get_required_objects

  # GET /groups/:group_group_id/topics
  def index
    @topic = Group::Topic.new # Pour le formulaire
    @topics = @group.topics.order('updated_at DESC').includes({comments: :user}, :user).page(params[:page])
  end

  # POST /groups/:group_group_id/topics
  def create
    @topic = Group::Topic.new(topic_params)
    @topic.user = current_user
    @topic.group = @group
    if @topic.save
      redirect_to group_group_topic_path(group_group_id: @group, id: @topic), notice: t('groups.topics.create.success')
    else
      render :new
    end
  end

  def edit
    @topic = @group.topics.where(id: params[:id]).take
  end

  def new
    @topic = Group::Topic.new
  end

  def show
    @topic = @group.topics.where(id: params[:id]).take
    @comments = @topic.comments.page(params[:page])
    render :show
    @topic.views += 1
    @topic.save
  end

  # def destroy
  #   topic = @group.topics.where(id: params[:id]).take
  #   comments = topic.comments
  #   comments.each { |comment| comment.destroy }
  #   topic.delete
  #   redirect_to group_work_group_topics_path, notice: 'supprimé.'
  # end

  private

  def topic_params
    params.require(:group_topic).permit(:title, :message)
  end

  def get_required_objects
    @comment = Group::Comment.new
    @group = Group::Group.find(params[:group_group_id])
  end
end