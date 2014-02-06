module ApplicationHelper
  include DeviseHelper
  def title(page_title)
    title = page_title == 'Memento' ? '' : "#{page_title}"
    content_for :title, title
  end

  def nav_link(link_text, page, *stuff)
    class_name = current_page?(page) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, page, *stuff
    end
  end
end

module LocalizationHelper
  def set_flash_message(key, kind, options = {})
    message    = find_message kind, options
    flash[key] = message if message.present?
  end

  def resource_params
    params.fetch resource_name, {}
  end

  def find_message(kind, options = {})
    options[:scope]           = controller_name
    options[:default]         = Array(options[:default]).unshift(kind.to_sym)
    options[:resource_name] ||= 'links'
    I18n.t "#{options[:resource_name]}.#{kind}", options
  end
end

module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages
    messages = messages.length > 1 ? messages.map { |msg| content_tag :li, msg }.join : messages.first

    sentence = I18n.t 'errors.messages.not_saved', :count => resource.errors.count, :resource => resource.class.model_name.human.downcase

    html = <<-HTML
    <div id="error_explanation">
      <h3>#{sentence}</h3>
      <div class="alert alert-warning">
        <a class="close" data-dismiss="alert">&#215;</a>
        #{messages}
      </div>
    </div>
    HTML

    html.html_safe
  end
end