class Permission

  attr_accessor :actions

  def initialize
    @actions = {}
  end

  def reset
    @actions = {}
  end

  def add(action, &block)
    @actions[action] = block
  end

  def authorized?(action, *args)
    block = actions[action]
    matches_action?(action) and (no_block? block or true_block? block, args)
  end

  private

  def matches_action?(action)
    actions.include? action
  end

  def no_block?(block)
    block.nil?
  end

  def true_block?(block, args)
    block.try(:call, args)
  end
end