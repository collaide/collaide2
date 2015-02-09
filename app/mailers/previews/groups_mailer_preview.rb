class GroupsMailerPreview < ActionMailer::Preview

  def new_invitation
    ei = Group::EmailInvitation.create(group: Group::Group.find(1), sender: User.find(1), message: 'salut', secret_token: SecureRandom.hex(16), email: 'facenord.sud@gmail.com')
    GroupsMailer.new_invitation(ei)
  end
end