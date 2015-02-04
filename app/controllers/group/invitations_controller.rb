# Contrôlleur responsable de la gestion des invitations
# C-a-d, demander à une personne inscrite ou non sur collaide à rejoindre un groupe
class Group::InvitationsController < ApplicationController
  before_action :find_the_group

  # Liste toutes les invitations qui n'ont pas reçues de réponses positives du groupe
   def index

   end

  private

  def find_the_group
    @group = Group::Group.find params[:group_group_id]
  end
end
