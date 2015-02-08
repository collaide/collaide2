class   User < ActiveRecord::Base
  extend Enumerize

  after_create :send_email

  mount_uploader :avatar, UserUploader

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable, :omniauthable

  enumerize :role, in: [:admin, :moderator, :author, :banned, :super_admin, :doc_validator, :add_validator], scope: true, predicates: true

  # Les invitations que l'utilisateur a envoyées
  has_many :sent_invitations, class_name: 'Group::Invitation', foreign_key: 'sender_id'
  # les invitations reçues
  has_many :received_invitations, class_name: 'Group::Invitation', foreign_key: 'receiver_id'

  # Les différents groupes auquels appartient l'utilisateur
  has_many :group_members, class_name: 'Group::GroupMember'
  has_many :groups, class_name: 'Group::Group', through: :group_members

  # Les groupes créés par un utilisateur
  has_many :groups_created, class_name: 'Group::Group'

  # Les notifications d'un utilisateur
  has_many :notifications

  validates :name, presence: true

  #https://github.com/alexreisner/geocoder
  geocoded_by :current_sign_in_ip   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  validates :points, numericality: {
      only_integer: true
  }

  scope :search_by_email_or_name, -> (term) { where('email LIKE :email or name LIKE :name', email: "%#{term}%", name: "%#{term}%").limit 10 }

  #################################################
  ############## MODULE ACTIVITIES ################
  #################################################
  has_many :params_activities, as: :owner, :class_name => 'Activity::Parameter'

  def activities
    params = self.params_activities.to_a
    where_sql = ''
    where_params = []
    params.each do |p|
      where_sql += ' (
      ((activity_activities.trackable_id = ? AND activity_activities.trackable_type = ?) OR
      (activity_activities.recipient_id = ? AND activity_activities.recipient_type = ?))
      AND (activity_activities.created_at between ? and ?)
      ) OR '
      where_params << p.trackable.id << p.trackable.class.base_class.to_s << p.trackable.id << p.trackable.class.base_class.to_s << p.starting_at << p.ending_at
    end
    where_sql += "activity_activities.public = 't'"

    Activity::Activity.where(where_sql, *where_params)
  end
  has_many :activities, through: :params_activities, :class_name => 'Activity::Activity'

  #################################################
  ################ FIN ACTIVITIES #################
  #################################################

  # Renvoi le nom de l'utilisateur
  def to_s
    self.name
  end

  # Essaie de donner un nom unique à l'utilisateur, basé sur l'adresse, mail
  def to_single_name
    self.name+" (#{self.email[0 ]}...@#{self.email.split('@').last.to_s})"
  end

  def self.find_for_facebook_oauth(auth)
    if (user = User.find_by(email: auth.info.email))
      return user
    end
    # where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
    where(provider: auth[:provider], uid: auth[:uid]).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      avatar = process_avatar(auth.info.image)
      user.remote_avatar_url = avatar if avatar # assuming the user model has an image
      user.save!
    end
  end

  def self.find_for_google_oauth2(auth)
    if (user = User.find_by(email: auth.info.email))
      return user
    end
    # where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
    where(provider: auth[:provider], uid: auth[:uid]).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      avatar = process_avatar(auth.info.image)
      user.remote_avatar_url = avatar if avatar # assuming the user model has an image
      user.save!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.process_avatar(uri)
    response = Net::HTTP.get_response(URI(uri))
    case response
      when Net::HTTPSuccess then
        return uri
      when Net::HTTPRedirection then
        return response['location']
      else
        return false
    end
  end

  private

  def send_email
    NotificationsMailer.signup(self).deliver_later
  end

end

class Point
  DOWNLOAD_DOCUMENT = 3
end
