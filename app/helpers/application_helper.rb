module ApplicationHelper

  # Return a string suitable for displaying a CC as last 4 digis
  def last_four(digits)
    cc_string = ""
    (0..2).each do 
      cc_string += "**** "
    end
    cc_string += digits
  end

  def flash_class(level)    
    case level.to_sym
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-error"
      when :alert then "alert alert-error"
    end
  end

  def fmt_date(timestamp)
    Time.at(timestamp.to_i).utc.to_datetime.strftime("%B %d, %Y")
  end

  def fmt_amount(amount)
    dollars = amount.to_i / 100
    cents = amount.to_i % 100
    sprintf("$%d.%02d", dollars, cents)
  end

  def active_tab(controller)
    if controller.is_a?(Array)
      if controller.include?(controller_name)
        return "active"
      else
        return ""
      end
    else
      if controller_name == controller
        return "active"
      else
        return ""
      end
    end
  end

  def select_sub_nav
    if ["spaces", "admins", "locations"].include? controller_name
      return "shared/settings"
    elsif ["members"].include? controller_name
      return nil
    end
  end

  def field_errors(obj, field)
    msg = nil
    # To get all errors associated with a single attribute, do the following:
    if !obj.errors[field].blank?
      errors = obj.errors[field]
      if errors.kind_of?(Array)
        msg = errors.join(", ")
      else
        msg = name_errors
      end
    end

    unless msg.blank?
      return "<span class='help-block'>#{msg}</span>".html_safe
    else
      return ""
    end
  end

  def has_error(obj, field)
    if !obj.errors[field].blank?
      return "has-error" 
    else
      return ""
    end
  end
end
