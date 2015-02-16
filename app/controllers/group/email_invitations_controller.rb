class Group::EmailInvitationsController < ApplicationController
  before_action :find_required_objects

  # N'importe quel utilisateur qui clique sur le lien (il possède le secret token)
  # peut rejoindre le groupe
  # TODO Gérer le cas d'un utilisateur enregistré, inviter par email qui créé un nouveau compte
  # Ce cas est rare. Il arrive uniquement dans le cas suivant:
  # 1. Une personne invite qqn par email
  # 2. Entre temps, cette personne s'inscrit sur collaide
  # 3. Cette personne reçoit le mail d'invitation
  def update
    authorize
    # TODO Gérer le cas d'une invitation marquée comme supprimée
    redirect_to back, alert: t('groups.email_invitations.error') and return if @ei.nil?
    if @ei.secret_token = params[:secret_token]
      case params[:status]
        when 'later'
          @ei.status = :later
          @ei.save
          redirect_to user_path(current_user), notice: t('groups.invitations.update.notice.later')
        when 'refused'
          @ei.status = :refused
          @ei.save
          redirect_to user_path(current_user), notice: t('groups.invitations.update.notice.refuse')
        # par défaut l'invitation est acceptée
        else
          if @ei.status == :accepted
            redirect_to group_group_path(@ei.group), notice: t('groups.invitations.update.notice.already_member')
          end
          @group = Group::Group.find params[:group_group_id]
          if @group.add_members current_user, joined_method: :was_invited_by_email, invited_or_added_by: @ei.sender
            @ei.status = :accepted
            @ei.save
          else
            redirect_to back, alert: t('groups.email_invitations.error')
            return
          end
          redirect_to group_group_path(@group), notice: t('group.email_invitations.member')
      end
    else
      redirect_to back, notice: t('groups.email_invitations.error')
    end
  end

  # TODO ne pas supprimer l'invitation mais lui changer un attribut
  def destroy
    authorize @group
    @ei.destroy
    redirect_to group_group_invitations_path, notice: t('groups.invitations.destroy.notice')
  end

  private
  def find_required_objects
    @group = Group::Group.find params[:group_group_id]
    @ei = @group.email_invitations.where(id: params[:id]).take!
  end
end