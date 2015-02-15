class Ability

  def initialize(user)
    controllers.each do |c|
      c.permission.reset
    end
    @@controllers = []
    define_permissions(user)
  end

  def controllers
    @@controllers ||= []
  end

  protected

  def define_permissions(user)
    can :index, Group::InvitationsController
  end

  private
  def can(action, controller, &block)
    controllers << controller
    controller.permission.add(action, &block)
  end
end