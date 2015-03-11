class Group::EmailInvitationsController < ApplicationController
  include Concerns::ActivityConcern

  before_action :find_required_objects
  before_action :authorize, except: :destroy
  before_action :ensure_email_invitation, except: :update
  before_action :check_secret_token, except: :destroy

  # N'importe quel utilisateur qui clique sur le lien (il possède le secret token)
  # peut rejoindre le groupe
  # TODO Gérer le cas d'un utilisateur enregistré, inviter par email qui créé un nouveau compte
  # Ce cas est rare. Il arrive uniquement dans le cas suivant:
  # 1. Une personne invite qqn par email
  # 2. Entre temps, cette personne s'inscrit sur collaide
  # 3. Cette personne reçoit le mail d'invitation
  def update
    # TODO Gérer le cas d'une invitation marquée comme supprimée
    if @ei.nil?
      redirect_to back, alert: t('groups.email_invitations.invitation_destroyed')
    elsif @ei.status == :accepted
      redirect_to group_group_path(@ei.group), notice: t('groups.invitations.update.notice.already_accepted')
    else
      case get_status
        when 'later'
          reply_later
        when 'refused'
          invitation_refused
        else # Par défaut, l'invitation est acceptée
          accept_invitation
      end
    end
  end

  def confirm
  end

  def send_confirmation
    @group.send_invitations current_user.email
    GroupsMailer.send_confirmation(@ei).deliver_later
    redirect_to user_path(current_user), notice: t('groups.email_invitations.confirmation_sended')
  end

  def clear_session
    reset_session
    redirect_to group_group_email_invitations_path(group_group_id: @group, id: @ei.id, secret_token: @ei.secret_token)
  end

  # TODO ne pas supprimer l'invitation mais lui changer un attribut
  def destroy
    authorize @group
    @ei.destroy
    redirect_to group_group_invitations_path, notice: t('groups.invitations.destroy.notice')
  end

  private

  def get_status
    status = params[:status]
    return status['status'] if status.respond_to? :[]
    if status.nil?
      params[:group_email_invitation][:status]
    else
      status
    end
  end

  def get_group
    @group = Group::Group.find params[:group_group_id]
  end

  def already_member?
    @group.is_a_member? current_user
  end

  def invitation_refused
    @ei.status = :refused
    @ei.receiver = current_user
    @ei.save
    create_group_activity :email_invitation_refused, :info, recipient: @ei.email
    redirect_to user_path(current_user), notice: t('groups.invitations.update.notice.refuse')
  end

  def reply_later
    @ei.status = :later
    @ei.receiver = current_user
    @ei.save
    redirect_to user_path(current_user), notice: t('groups.invitations.update.notice.later')
  end

  def accept_invitation
    get_group
    if already_member?
      redirect_to group_group_path(@group), notice: t('group.email_invitations.already_member')
    elsif add_current_user
      redirect_to group_group_path(@group), notice: t('group.email_invitations.member')
    else
      redirect_to back, alert: t('groups.email_invitations.error')
    end
  end

  def add_current_user
    @group.add_members current_user, joined_method: :was_invited_by_email, invited_or_added_by: @ei.sender
    @ei.receiver = current_user
    @ei.status = :accepted
    @ei.save
    create_group_activity :joined, :addition, recipient: current_user
  end

  def find_required_objects
    @group = Group::Group.find params[:group_group_id]
    @ei = @group.email_invitations.where(id: params[:id]).take
  end

  def ensure_email_invitation
    raise_record_not_found if @ei.nil?
  end

  def check_secret_token
    redirect_to back, notice: t('groups.email_invitations.bad_secret_token') if @ei.respond_to? :secret_token and @ei.secret_token != params[:secret_token]
  end

  def email_matches?
    current_user.email == @ei.email
  end
end