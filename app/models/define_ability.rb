class DefineAbility
  attr_accessor :action_controller, :namespace_controller

  def initialize(user)
    @action_controller = {}
    @namespace_controller = nil
    controllers.each do |c|
      c.permission.reset
    end
    @@controllers = []
    define!(user)
  end

  def controllers
    @@controllers ||= []
  end

  protected

  def define!(user)
  end

  def module_name(namespace, &block)
    @namespace_controller = namespace
    block.call
    @namespace_controller = nil
  end

  def controller(controller_class, &block)
    unless namespace_controller.nil?
      controller_class = namespace_controller.to_s + '/' + controller_class.to_s
    end
    block.call
    action_controller.each do |action, can_block|
      rule action, controller_class, &can_block
    end
  end

  def can(action, &block)
    if action.try(:each) { |a| can(a, &block) }
    else
      action_controller[action] = block
    end
  end

  def rule(action, _controller_class, &block)
    controller_class = if _controller_class.respond_to?(:camelize)
                         _controller_class += '_controller' if not _controller_class.end_with? '_controller'
                         _controller_class.camelize.constantize
                       else
                         _controller_class
                       end
    controllers << controller_class
    unless controller_class.respond_to? :permission
      raise NoPermissionsException.new("The controller #{controller_class} does not have a method permission")
    end
    controller_class.permission.add(action, &block)
  end
end

class NoPermissionsException < Exception
  def initialize(msg)
    super msg
  end
end