class Ability

  attr_accessor :rules

  def initialize(user)
    @rules = {}
    define_permissions(user)
  end

  protected

  def define_permissions(user)
    can :index, Group::InvitationsController
  end

  def can(action, controller, &block)
    controller.permission.add(action, &block)
  end
end