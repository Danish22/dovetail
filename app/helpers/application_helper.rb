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

end
