# Une invitation est liée à un groupe (invitation à rejoinde un groupe donné),
# est créée par quelqu'un (un User) et pour quelqu'un un autre User
class Group::Invitation < ActiveRecord::Base

  extend Enumerize
  enumerize :status, in: [:accepted, :pending, :later, :refused], default: :pending, predicates: true

  scope :pending, -> { where(status: :pending) }
  scope :later, -> { where(status: :later) }
  scope :wait_a_reply, -> { where("group_invitations.status='later' OR group_invitations.status='pending'") }
  scope :responded, -> {where("group_invitations.status='refused' OR group_invitations.status='accepted'")}


  # Celui qui emet l'invitation
  belongs_to :sender, class_name: 'User'

  # Pour quel groupe
  belongs_to :group, :class_name => 'Group::Group'

  # Celui qui reçoit l'invitation
  belongs_to :receiver, class_name: 'User'

  # The receiver is added to the group
  def accept
    self.status = :accepted
    self.group.add_members(self.receiver, self.role, :was_invited, self.sender)
    self.save
  end

  def waiting_a_reply?
    pending? or later?
  end

  def decline
    self.status = :refused
    self.save
  end

  def chose_later
    self.status = :later
    self.save
  end
end
