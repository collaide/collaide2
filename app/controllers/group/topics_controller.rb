class Group::TopicsController < ApplicationController
  before_action :get_required_objects

  # GET /groups/:group_group_id/topics
  def index
    @topic = Group::Topic.new # Pour le formulaire
    @topics = @group.topics.order('updated_at DESC').includes({comments: :user}, :user).page(params[:page])
  end

  def edit
    check_permission { @group.can? :write, :topic, current_user }
    @topic = @group.topics.where(id: params[:id]).take
  end

  def new
    check_permission{ @group.can? :write, :topic, current_user }
    @topic = Topic.new
  end

  def show
    check_permission{ @group.can? :read, :topic, current_user }
    @topic = @group.topics.where(id: params[:id]).take
    @comments = @topic.comments.page(params[:page])
  end

  def destroy
    check_permission { @group.can? :delete, :topic, current_user }
    topic = @group.topics.where(id: params[:id]).take
    comments = topic.comments
    comments.each { |comment| comment.destroy }
    topic.delete
    redirect_to group_work_group_topics_path, notice: 'supprimé.'
  end

  private
  def get_required_objects
    @comment = Group::Comment.new
    @group = Group::Group.find(params[:group_group_id])
  end
end