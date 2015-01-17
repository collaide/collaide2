module ApplicationHelper
  def build_active_menu(name, content, compar_to = nil)
    compar_to ||= params[:action]
    if name.to_s == compar_to
      html_class = 'class="active"'
    else
      html_class = ''
    end
    "<li #{html_class}>#{h(content)}</li>".html_safe
  end
end
