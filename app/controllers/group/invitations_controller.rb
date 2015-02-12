# Contrôlleur responsable de la gestion des invitations
# C-a-d, demander à une personne inscrite ou non sur collaide à rejoindre un groupe
class Group::InvitationsController < ApplicationController
  before_action :find_the_group

  # Liste toutes les invitations qui n'ont pas reçues de réponses positives du groupe
   def index
     @invitation = Group::DoInvitation.new
   end

  def create
    do_invitation = Group::DoInvitation.new(group_invitation_params)
    do_invitation.group_id = params[:group_group_id]
    if do_invitation.valid?
      @group.send_invitations(do_invitation, sender: current_user)
      redirect_to group_group_invitations_path(@group), notice: t('groups.invitations.create.notice')
    else
      @invitation = do_invitation
      render 'group/invitations/new'
    end
  end

  def destroy
    @invitation = @group.invitations.where(id: params[:id]).take!
    @invitation.destroy
    redirect_to group_group_invitations_path, notice: t('groups.invitations.destroy.notice')
  end

  private

  def find_the_group
    @group = Group::Group.find params[:group_group_id]
  end

  def group_invitation_params
    params.require(:group_do_invitation).permit(:users_id, :email_list, :message)
  end
end
