# Un topic permet de lancer une nouvelle discussion dans un groupe.
# A nouveau, comme pour les commen, les relations sont en dure (plus simple et rien d'autre de prévu à court ou moyen terme)
class Group::Topic < ActiveRecord::Base

  # Un topic appartient à un groupe (une discussion dans le groupe)
  belongs_to :group, class_name: 'Group::Group'

  # Un topic est crée par un utilisateur
  belongs_to :user

  # Un topic peut avoir entre 0 et infini commentaire (ie: réponses)
  has_many :comments, class_name: 'Group::Comment', dependent: :destroy

  # Un topic doit au miniumu avoir un message, un utilisateur et appartenir à un groupe
  validates_presence_of :message
  validates_presence_of :user
  validates_presence_of :group

  def to_s
    if title.blank?
      # Affiche les trentes premiers caractères du messages, si il n'y a pas de titre
      ActionController::Base.helpers.strip_tags(message).truncate(30).html_safe
    else
      title
    end
  end
end
