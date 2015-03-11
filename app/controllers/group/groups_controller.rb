class Group::GroupsController < ApplicationController

  include Concerns::ActivityConcern


  def create
    @group = Group::Group.new(name: group_params[:name], steps: :user_login) # Créé un nouveau groupe
    # Si l'utilisateur est loggué, on le met comme créateur du groupe et le prochain pas est les invitations
    if user_signed_in?
      @group.user = current_user
      @group.steps = :invitations
    end
    if @group.save
      create_activity(:create, trackable: @group, owner: current_user)
      # On redirige vers le prochain pas à effectuer (utilisateur déconnecté = pas de connxion sinon inviter des gens)
      redirect_to eval("group_group_create_#{@group.steps}_path(group_group_id: #{@group.id})")
    else
      render :new
    end
  end

  def new
    @group = Group::Group.new
  end

  def show
    @group = Group::Group.find params[:id]
    @activities = Activity::Activity.order("created_at desc").where('(trackable_id = ? AND trackable_type = ?) OR (recipient_id = ? AND recipient_type = ?) OR (owner_id = ? AND owner_type = ?)', @group.id, @group.class.base_class.to_s, @group.id, @group.class.base_class.to_s, @group.id, @group.class.base_class.to_s)
  end

  private

  def group_params
    params.require(:group_group).permit(:name)
  end
end