# Une invitation par e-amil est pour les personnes qui ne sont pas membres de collaide
# Comme pour une invitation classique, il y a un sender qui émet l'invitation pour un certain groupe
# Mais il n'y a pas de personnes qui reçoivent l'invitation, uniquement une adresse e-mail
class Group::EmailInvitation < ActiveRecord::Base
  extend Enumerize
  enumerize :status, in: [:accepted, :pending, :later, :refused], default: :pending, predicates: true

  scope :wait_a_reply, -> { where("group_email_invitations.status='later' OR group_email_invitations.status='pending'") }

  belongs_to :group, :class_name => 'Group::Group'
  belongs_to :sender, class_name: 'User'
end
