# Permet de faire une liaison many to many entre les ustilisateurs et les groupes
# Indique le rôle du membre du groupe et comment il a rejoint le groupe
class Group::GroupMember < ActiveRecord::Base
  #attr_accessible :is_admin
  extend Enumerize
  enumerize :role, in: [:admin, :member, :visitor], predicates: true

  # Comment il a rejoint le groupe
  enumerize :joined_method, in: [:was_invited,
                                  :was_added,
                                  :was_invited_by_email,
                                  :by_itself], default: :by_itself

  # Le User qui l'a ajouté ou invité
  belongs_to :invited_or_added_by, class_name: 'User'

  # L'utilisateur
  belongs_to :user

  # Le group
  belongs_to :group, :class_name => 'Group::Group'


  # Recherche si le User +user+ passé en paramètre est membre du Group:Group +group+
  # Retourne nil si pas trouvé, sinon une instance de cette classe
  def self.get_a_member(user, group)
    return nil if user.nil?
    where(group: group, user: user).take
  end
end
