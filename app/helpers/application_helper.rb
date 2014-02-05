module ApplicationHelper
  def title(page_title)
    title = page_title == 'Memento' ? '' : "#{page_title}"
    content_for :title, title
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