class Integrations::MailchimpsController < Integrations::BaseController

  protected

  def prepare_integration
    @integration = @space.integrations.where(type: 'MailchimpIntegration').first || MailchimpIntegration.new
    @connected = @integration.connected?
    @configured = @integration.configured?
  end

  def redirect_url
    integrations_mailchimp_url
  end

  def new_record
    integration = MailchimpIntegration.new(params[:mailchimp_integration])
    integration.space = @space
    integration
  end

  def update_entity
    @integration.update_attributes(params[:mailchimp_integration])
  end

  def assign_updates
    @integration.assign_attributes(params[:mailchimp_integration])
  end

  def integration_name
    "MailChimp"
  end
end
