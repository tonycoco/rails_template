module BootstrapHelper
  def yield_for(content_sym, default)
    content_yield = content_for(content_sym)
    content_yield.blank? ? default : content_yield
  end

  def body_css_classes
    c = []
    c << controller_name
    c << action_name
    c << yield_for(:body_class, nil)
    c
  end

  def alert_css_class_for(key)
    case key.to_sym
    when :alert
      'error'
    when :notice
      'success'
    else
      key.to_s
    end
  end

  def alert_heading_for(key)
    case key.to_sym
    when :alert
      I18n.t('alert_message.alert')
    when :notice
      I18n.t('alert_message.notice')
    else
      I18n.t('alert_message.default')
    end
  end

  def alert_message_for(flash, options={})
    return '' if flash.blank?

    keys = flash.keys.select { |key| !key.match(options[:except]) } rescue []

    if keys.blank?
      keys.each do |key|
        next if flash[key].blank?

        message = content_tag(:p, "#{content_tag(:strong, alert_heading_for(key))} #{flash[key]}")
        close_button = link_to('&times;'.html_safe, '#', :class => 'close')

        content_tag(:div, "#{close_button}#{message}".html_safe, :class => "alert-message #{alert_css_class_for(key)}", :'data-alert' => 'alert')
      end
    end
  end

  def alert_block_for(errors, type='error', options={})
    return '' if errors.empty?

    message = content_tag(:p, "#{content_tag(:strong, alert_heading_for(type))} #{pluralize(errors.count, 'error')} prevented this from being saved.")
    errors_list = content_tag(:ul, errors.full_messages.map { |msg| content_tag(:li, msg) }.join)
    close_button = link_to('&times;'.html_safe, '#', :class => 'close')

    content_tag(:div, "#{close_button}#{message}#{errors_list}".html_safe, :class => "alert-message block-message #{css_class_for(type)}", :'data-alert' => 'alert')
  end
end
