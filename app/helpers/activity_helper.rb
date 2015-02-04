# -*- encoding : utf-8 -*-
module ActivityHelper
  # View helper for rendering an activity, calls {Activity::Activity#render} internally.
  def render_activity activities, options = {}
    if activities.is_a? Activity::Activity
      activities.render self, options
    elsif activities.respond_to?(:map)
      return nil if activities.empty?
      # depend on ORMs to fetch as needed
      # maybe we can support Postgres streaming with this?
      activities.map {|activity| activity.render self, options.dup }.join.html_safe
    end
  end
  alias_method :render_activities, :render_activity

  # Helper for setting content_for in activity partial, needed to
  # flush remains in between partial renders.
  def single_content_for(name, content = nil, &block)
    @view_flow.set(name, ActiveSupport::SafeBuffer.new)
    content_for(name, content, &block)
  end

  # Activities show the owner
  def show_owner(owner)
    if owner
      raw(link_to(h(owner.name), owner))
    else
      t'activity.unknown'
    end
  end

end