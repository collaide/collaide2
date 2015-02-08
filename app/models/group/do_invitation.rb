# Permet de valider et mettre en forme les données reçues par le formulaire d'invitations
# Le formulaire d'invitation renvoi un String contenant des adresses e-mails et des id séparés par
# des virgules. À partir de ce String, on obtient une liste d'adresses e-mails valides et une liste de User
class Group::DoInvitation
	include ActiveModel::Model
	include ActiveModel::Validations
	include ActiveModel::Validations::Callbacks

	attr_accessor :email_list, :users_id, :group_id, :message, :users
  after_validation :prepare_for_save

  validates_with Group::DoInvitationValidator

  protected
  def prepare_for_save
    e_list = []
    id_list = []
    users_id.split(',').each do |entry|
      if entry.to_i <= 0
        e_list << entry
      else
        id_list << entry
      end
    end
    self.email_list = e_list
    self.users = id_list
  end
end