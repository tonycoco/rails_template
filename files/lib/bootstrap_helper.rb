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

  def alert_message_css_class_for(key)
    case key.to_sym
    when :alert
      return 'error'
    when :notice
      return 'success'
    else
      return key.to_s
    end
  end

  def alert_message_heading_for(key)
    case key.to_sym
    when :alert
      return I18n.t('alert_message.alert')
    when :notice
      return I18n.t('alert_message.notice')
    else
      return I18n.t('alert_message.default')
    end
  end

  def alert_message_for(flash, options={})
    except = options[:except]
    keys = flash.keys.select { |key| !key.match(except) } rescue []

    unless keys.blank?
      keys.each do |key|
        next if flash[key].blank?

        flash_text = content_tag(:p, content_tag(:strong, alert_message_heading_for(key)) + ' ' + flash[key])
        close_button = link_to('&times;'.html_safe, '#', :class => 'close')
        return content_tag(:div, (close_button + flash_text).html_safe, :class => "alert-message #{alert_message_css_class_for(key)}", :'data-alert' => 'alert')
      end
    end
  end
end
