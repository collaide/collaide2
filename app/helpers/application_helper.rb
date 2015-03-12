module ApplicationHelper

  # Used to give a title to a page. If the params +text+ is blank
  # the title is taken from the translation file (fr.yml), if it exists
  def title(text)
    generate_meta :title, text
  end

  def back
    request.env['HTTP_REFERER'] || root_path
  end

  # generate a <li> tag and added the html class active if the +path+ is equal to the current_path
  # +path+ is the path of the link where the item land for, blank by deafult
  # +text+ is the text of the item, blank by default
  # +icon+ is a icon from foundation in large format. Just give the name of the icon without the fi-, nil by default
  def build_active_menu(path: '', text: '', icon: nil, controller: nil)
    if (controller.nil? and path == request.fullpath) or controller == params[:controller]
      html_class = 'class="active"'
    else
      html_class = ''
    end
    icon.nil? ? fi_icon = '' : fi_icon = foundation_icons("fi-#{icon} large")
    "<li #{html_class}>#{link_to(fi_icon + h(text), path)}</li>".html_safe
  end

  # add a foundation icon
  def foundation_icons(classes)
    "<i class='#{h(classes)}'></i> ".html_safe
  end

  # Used for hiding part of the form for editing user's profile
  def hide_for?(view)
    params[:view] != view.to_s ? 'hide' : nil
  end

  # Generate an image which represent a left arrow
  def left_arrow(path)
    link_to image_tag('left-arrow.png', width: 25, height: 25), path
  end

  # Print the title of the topic
  def print_topic_title(t)
    t.title.blank? ? strip_tags(t.message).truncate(100, seprator: ' ') : t.title
  end

  # Print the user image in a really small format
  def user_image(user, size: :mini, name: false)
    case size
      when :mini
        height = 25
        width = 25
        image = user.avatar.mini
      when :small
        height = 50
        width = 50
        image = user.avatar.mini
    end
    content = image_tag(image, class: 'th', height: height, width: width)
    content += ' ' + h(user.to_s) if name
    link_to content, user_path(user)
  end

  def user_from_json(name, url, show)
    "<a href=\"#{url}\" ng-hide=\"#{show}\""">#{h(name)}</a>".html_safe
  end

  # Print to the topbar an item to read the notifications and show the number of unreaded notifications
  def print_unread_notifications
    return unless user_signed_in?
    notifications_size = current_user.notifications.where(is_viewed: false).size
    # todo: update with the current_path method
    # ie: current_page?(:controller => 'users', :action => 'index')
    if notifications_size > 0 and request.fullpath != user_notifications_path(current_user)
      "<li><a href='#{user_notifications_path(current_user)}'>#{t('header.user.notifications', size: notifications_size)}</a></li>".html_safe
    end
  end

  # Determine the super type of an item (file or folder). A super type is text or image, etc
  # return true or false depending on +type+
  def determine_super_type(item, type)
    not item.is_folder? and item.content_type.include? type
  end

  def icon_from_activity(activity)
    case activity.activity_type
      when 'addition'
        foundation_icons('fi-plus large')
      when 'deletion'
        foundation_icons('fi-minus large')
      else
        foundation_icons('fi-info large')
    end
  end

  private
  def generate_meta(meta, text = '')
    if text.blank?
      return find_translations meta
    end
    text
  end

  def find_translations(meta)
    translation = []
    action_name = params[:action]
    action_name = 'new' if action_name == 'create'
    translation << action_name
    resource = params[:controller].split('/')
    translation << resource[1]
    translation << resource[0]
    translation << meta.to_s.pluralize
    translation.reverse!.reject! {|term| term.blank?}
    logger.debug "looking translation for SEO in: #{translation.join '.'}"
    t(translation.join('.'), default: t("default_#{meta.to_s}")) + ' - ' + t('app_name')
  end
end
