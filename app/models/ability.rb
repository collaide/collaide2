class Ability

  def initialize(user)
    can :update, Group::Invitation do |group, invitation|
      group.can? and invitation.id
    end
  end
end