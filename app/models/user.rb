class   User < ActiveRecord::Base
  extend Enumerize

  mount_uploader :avatar, UserUploader

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable, :omniauthable

  enumerize :role, in: [:admin, :moderator, :author, :banned, :super_admin, :doc_validator, :add_validator], scope: true, predicates: true

  validates :name, presence: true

  #https://github.com/alexreisner/geocoder
  geocoded_by :current_sign_in_ip   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  validates :points, numericality: {
      only_integer: true
  }

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
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
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
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
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

end

class Point
  DOWNLOAD_DOCUMENT = 3
end
