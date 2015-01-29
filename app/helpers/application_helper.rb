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
  def build_active_menu(path: '', text: '', icon: nil)
    if path == request.fullpath
      html_class = 'class="active"'
    else
      html_class = ''
    end
    icon.nil? ? fi_icon = '' : fi_icon = foundation_icons("fi-#{icon} large")
    "<li #{html_class}>#{link_to(fi_icon + h(text), path)}</li>".html_safe
  end

  # add a foundation icon
  def foundation_icons(classes)
    "<i class=\"#{h(classes)}\"></i> ".html_safe
  end

  # Used for hiding part of the form for editing user's profile
  def hide_for?(view)
    params[:view] != view.to_s ? 'hide' : nil
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
