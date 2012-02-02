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
      'alert-error'
    when :notice
      'alert-success'
    else
      'alert-' + key.to_s
    end
  end

  def alert_heading_for(key)
    case key.to_sym
    when :alert
      t('alerts.headings.alert')
    when :notice
      t('alerts.headings.notice')
    else
      t('alerts.headings.default')
    end
  end

  def alert_message_for(flash, options={})
    return '' if flash.blank?

    keys = flash.keys.select { |key| !key.match(options[:except]) } rescue []

    unless keys.blank?
      keys.each do |key|
        next if flash[key].blank?

        html = ''
        html << link_to('&times;'.html_safe, '#', :class => 'close', :'data-dismiss' => 'alert')
        html << content_tag(:strong, alert_heading_for(key))
        html << ' '
        html << flash[key]

        return content_tag(:div, html.html_safe, :class => "alert #{alert_css_class_for(key)}")
      end
    end
  end

  def alert_block_for(errors, type='error', options={})
    return '' if errors.empty?

    html = ''
    html << link_to('&times;'.html_safe, '#', :class => 'close', :'data-dismiss' => 'alert')
    html << content_tag(:h4, "#{alert_heading_for(type)} There's #{pluralize(errors.count, 'error')} preventing this from being saved.", :class => 'alert-heading')
    html << content_tag(:ul, errors.full_messages.map { |msg| content_tag(:li, msg) }.join.html_safe)

    return content_tag(:div, html.html_safe, :class => "alert alert-block #{alert_css_class_for(type)}")
  end
end
