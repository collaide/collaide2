class Group::Group < ActiveRecord::Base

  #include Concerns::ActivityConcern
  extend Enumerize

  ROLES = [:all, :admin, :writer, :member]

  has_repository

  serialize :can_index_activity, Array
  enumerize :can_index_activity, in: ROLES, multiple: true

  serialize :can_delete_group, Array
  enumerize :can_delete_group, in: ROLES, multiple: true

  serialize :can_index_members, Array
  enumerize :can_index_members, in: ROLES, multiple: true
  serialize :can_read_member, Array
  enumerize :can_read_member, in: ROLES, multiple: true
  serialize :can_delete_member, Array
  enumerize :can_delete_member, in: ROLES, multiple: true

  serialize :can_write_file, Array
  enumerize :can_write_file, in: ROLES, multiple: true
  serialize :can_index_files, Array
  enumerize :can_index_files, in: ROLES, multiple: true
  serialize :can_read_file, Array
  enumerize :can_read_file, in: ROLES, multiple: true
  serialize :can_delete_file, Array
  enumerize :can_delete_file, in: ROLES, multiple: true

  serialize :can_index_topics, Array
  enumerize :can_index_topics, in: ROLES, multiple: true
  serialize :can_read_topic, Array
  enumerize :can_read_topic, in: ROLES, multiple: true
  serialize :can_write_topic, Array
  enumerize :can_write_topic, in: ROLES, multiple: true
  serialize :can_delete_topic, Array
  enumerize :can_delete_topic, in: ROLES, multiple: true

  serialize :can_create_invitation, Array
  enumerize :can_create_invitation, in: ROLES, multiple: true
  serialize :can_manage_invitations, Array
  enumerize :can_manage_invitations, in: ROLES, multiple: true

  enumerize :steps, in: [:user_login, :password, :invitations]
  
  before_create :add_owner_as_member

  # Pour la création du groupe étape par étape, enregistre les infos annexes au groupe
  has_one :group_creation, class_name: 'Group::GroupCreation'

  # Le créateur du groupe
  belongs_to :user
  has_many :group_members, class_name: 'Group::GroupMember'

  # Renvoi les membres du groupes
  has_many :members, through: :group_members, source: :user, class_name: 'User'

  # Les invitations envoyées à des utilisateurs pour qu'ils rejoingngent le groupe
  has_many :invitations, class_name: 'Group::Invitation'

  # Les invitations envoyées à des non-membres pour qu'ils rejoingnent le groupe
  has_many :email_invitations, foreign_key: 'group_group_id'

  # Les topics (discussions) d'un groupe
  has_many :topics, class_name: 'Group::Topic', dependent: :destroy

  def invitations_waiting_a_reply
    self.invitations.give_a_reply
  end

  def p_or_l_email_invitations
    self.email_invitations.give_a_reply
  end

  validates :name, presence: true, length: {minimum: 2}

  before_create :init

  def init
    # Files permissions
    self.can_write_file << :member
    self.can_read_file << :member
    self.can_delete_file << :member
    self.can_index_files << :member

    # Topics permissions
    self.can_delete_topic << :admin
    self.can_manage_invitations << :admin
    self.can_read_topic << :member
    self.can_index_topics << :member
    self.can_write_topic << :member

    # Group administrations permissions
    self.can_delete_group << :admin
    self.can_index_activity << :member
    self.can_delete_member << :admin
    self.can_index_members << :member
    self.can_read_member << :member
    self.can_create_invitation << :member
  end

  # send an invitation to the receivers
  def send_invitations(receivers, message: '', sender: self, receiver_type: 'User')
    if receivers.kind_of?(Array)
      receivers.each do |r|
        invitation = Group::Invitation.new(message: message)
        invitation.sender = sender
        if r.is_a? Fixnum or r.is_a? String
          invitation.receiver_id = r.to_i
          invitation.receiver_type = receiver_type
          #create_activity(:create, trackable: invitation, owner_id: r.to_i, owner_type: receiver_type)
        else
          invitation.receiver = r
          #create_activity(:create, trackable: invitation, recipient: r, owner: sender)
        end
        self.group_invitations << invitation
      end
    elsif receivers.is_a? Group::DoInvitation
      do_invitation receivers, sender: sender, receiver_type: receiver_type
    else
      invitation = Group::Invitation.new(message: message)
      invitation.sender = sender
      invitation.receiver = receivers

      #create_activity(:create, trackable: invitation, recipient: receivers, owner: sender)

      self.group_invitations << invitation
    end
  end

  # Ajoute un membre au groupe avec le role, la méthode et le user qui l'a ajouté ou invité
  # On ne peux pas ajouter deux fois le même membre.
  def add_members(members, role: :member, joined_method: :by_itself, invited_or_added_by: nil)
    if members.kind_of?(Array)
      members.each do |m|
        unless Group::GroupMember.where(group: self, member: m).take
          gm = Group::GroupMember.new
          gm.user = m
          gm.role = role
          gm.joined_method = joined_method
          gm.invited_or_added_by = invited_or_added_by
          self.group_members << gm
          self.save
          #create_activity(:joined, trackable: self, owner: m, create_related_activity_param: true)
        end
      end
    else
      unless Group::GroupMember.get_a_member members, self
        gm = Group::GroupMember.new
        gm.user = members
        gm.role = role
        gm.joined_method = joined_method
        gm.invited_or_added_by = invited_or_added_by
        self.group_members << gm
        #create_activity(:joined, trackable: self, owner: members, create_related_activity_param: true)
      end
    end
  end

  def to_s
    self.name
  end

  def can_not?(can_action, can_type, actor)
    not can?(can_action, can_type, actor)
  end

  def can?(can_action, can_type, actor)
    member_actor = (actor.is_a?(Group::GroupMember) ? actor : Group::GroupMember.get_a_member(actor, self))
    if member_actor.nil?
      can_do(can_action, can_type).empty?
    elsif member_actor.role.to_sym == :admin
      true
    elsif member_actor.role.to_sym == :all and can_do(can_action, can_type).empty?
      true
    else
      can_do(can_action, can_type).include?(member_actor.role.to_sym)
    end
  end

  private
  def add_owner_as_member
    self.add_members(self.user, role: :admin)
  end

  private
    def can_do(action, type)
      self.send("can_#{action.to_s}_#{type.to_s}")
    end

    def do_invitation(do_invitation, sender: self, receiver_type: 'User')
      do_invitation.users.each do |an_id|
        next if an_id.to_i < 1 or !an_id.to_i.is_a? Fixnum
        invitation  = Group::Invitation.new message: do_invitation.message,  receiver_type: receiver_type, receiver_id: an_id, sender: sender
        self.group_invitations << invitation
      end
      do_invitation.email_list.each do |an_email|
        if an_email =~ Group::DoInvitationValidator::VALID_EMAIL_REGEX
          a_user = User.find_by email: an_email
          if a_user
            invitation  = Group::Invitation.new message: do_invitation.message,  receiver_type: receiver_type, receiver_id: a_user.id, sender: sender
            self.group_invitations << invitation
          else
            ei = Group::EmailInvitation.create(
                email: an_email, message: do_invitation.message, group_group: self, user: sender, secret_token: SecureRandom.hex(16)
            )
            GroupMailer.new_invitation(ei).deliver
            ei.save
          end
        end
      end
    end

end