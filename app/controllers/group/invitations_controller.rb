# Contrôlleur responsable de la gestion des invitations
# C-a-d, demander à une personne inscrite ou non sur collaide à rejoindre un groupe
class Group::InvitationsController < ApplicationController
  include Concerns::ActivityConcern

  before_action :find_the_group

  # Liste toutes les invitations qui n'ont pas reçues de réponses positives du groupe
   def index
     authorize @group
     @invitation = Group::DoInvitation.new
   end

  def create
    authorize @group
    do_invitation = Group::DoInvitation.new(group_invitation_params)
    do_invitation.group_id = params[:group_group_id]
    if do_invitation.valid?
      @group.send_invitations(do_invitation, sender: current_user)
      create_group_activity :new_invitation, :addition
      redirect_to group_group_invitations_path(@group), notice: t('groups.invitations.create.notice')
    else
      @invitation = do_invitation
      render 'group/invitations/new'
    end
  end

  # L'utilisateur rejoint le groupe sur la base de l'invitation
  # Il rejoint le groupe uniquement si c'est l'utlisateur contenu dans l'invitation
  def update
    invitation = Group::Invitation.find params[:id]
    authorize invitation
    if invitation.status == :accepted
      redirect_to user_path(invitation.user), notice: t('groups.invitations.update.notice.already_member')
    end
    if get_status == 'accepted'
      group = Group::Group.find params[:group_group_id]
      group.add_members(invitation.receiver, joined_method: :was_invited, invited_or_added_by: invitation.sender)
      group.save
      create_group_activity :invitation_accepted, :addition, recipient: current_user
      invitation.status = 'accepted'
      invitation.save
      redirect_to group_group_path(group), notice: t('groups.invitations.update.notice.accept')
    elsif get_status == 'refused'
      invitation.status = :refused
      create_group_activity :invitation_refused, :info, recipient: invitation.receiver
      invitation.save
      redirect_to user_path(invitation.receiver), notice: t('groups.invitations.update.notice.refuse')
    elsif get_status == 'later'
      invitation.status = :later
      invitation.save
      redirect_to user_path(invitation.receiver), notice: t('groups.invitations.update.notice.later')
    else
      redirect_to user_path(invitation.receiver), notice: t('groups.invitations.update.notice.bordel')
    end
  end

  def destroy
    authorize @group
    @invitation = @group.invitations.where(id: params[:id]).take!
    create_group_activity :invitation_destroyed, :deletion, recipient: @invitation.receiver
    @invitation.destroy
    redirect_to group_group_invitations_path, notice: t('groups.invitations.destroy.notice')
  end

  private

  def get_status
    status = params[:status]
    return status['status'] if status.respond_to? :[]
    if status.nil?
      params[:group_invitation][:status]
    else
      status
    end
  end

  def find_the_group
    @group = Group::Group.find params[:group_group_id]
  end

  def group_invitation_params
    params.require(:group_do_invitation).permit(:users_id, :email_list, :message)
  end
end
