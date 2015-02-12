class GroupsMailerPreview < ActionMailer::Preview

  def new_invitation_from_email
    ei = Group::EmailInvitation.create(group: Group::Group.find(1), sender: User.find(1), message: 'salut', secret_token: SecureRandom.hex(16), email: 'facenord.sud@gmail.com')
    GroupsMailer.new_invitation_from_email(ei)
  end

  def new_invitation
    receiver = User.find 2
    sender = Group::Group.find(1).user
    invitation = Group::Invitation.new message: do_invitation.message, reciever: receiver, sender: sender
    GroupsMailer.new_invitation invitation
  end
end