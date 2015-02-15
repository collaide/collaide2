class Ability

  attr_accessor :rules

  def initialize(user)
    @rules = {}
    define_permissions
  end

  protected

  def define_permissions
    can :update, Group::Invitation do |group, invitation|
      group.can? and invitation.id
    end
  end

  def can(action, controller, &block)
    controller.permission.add(action, block)
  end
end