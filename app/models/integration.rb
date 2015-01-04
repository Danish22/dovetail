# Polymorphic (STI) base class for integrations

class Integration < ActiveRecord::Base

  serialize :settings, Hash

  belongs_to :space, touch: true

  attr_accessor :default_type
  attr_accessor :default_status
  
  # Only create/save the record if the connection
  # to the 3rd party app succeeded.
  def connected?
    return !new_record? && !settings.empty?
  end

  def configured?
    connected?
  end
 
end
