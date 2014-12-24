class Integrations::StripesController < Integrations::BaseController

  skip_before_filter :authenticate_user!, :only => [:callback]
  skip_before_filter :prepare_integration, :only => [:callback]
  skip_before_filter :set_space, :only => [:callback]

  def authorize
    params = {
      :scope => 'read_write',
      :state => @space.id,      
      # TODO Add prefil for stripe
    }
    
    # Redirect the user to the authorize_uri endpoint
    url = oauth_client.auth_code.authorize_url(params)
    redirect_to url
  end

  def callback

    space = Space.find(params[:state])

    unless params[:error]
      begin
        # Make a request to the access_token_uri endpoint to get an access_token
        @resp = oauth_client.auth_code.get_token(params[:code], :params => {:scope => 'read_write'})
                
        @integration = StripeIntegration.new(oauth_access_token: @resp.token, 
                                             oauth_refresh_token: @resp.refresh_token, 
                                             stripe_publishable_key: @resp.params['stripe_publishable_key'],
                                             remote_account_id: @resp.params['stripe_user_id'])
        
        @integration.space = space
        @integration.save

        redirect_to space_integrations_url(space, notice: "Connection to Stripe established")
      rescue Exception => e
        Rails.logger.info("Stripe exception: #{e.inspect}")
        redirect_to space_integrations_url(space, alert: "There was an error while retrieving token")
      end
    else
      redirect_to space_integrations_url(space, alert: "There was an error: #{params[:error_description]}")
    end

  end

  protected

  def prepare_integration
    @integration = @space.integrations.where(type: 'StripeIntegration').first || StripeIntegration.new
    @connected = @integration.connected?
    @configured = @integration.configured?
  end

  def redirect_url
    space_integrations_url(@space)
  end

  def assign_updates
    @integration.assign_attributes(params[:stripe_integration])
  end

  def integration_name
    "Stripe"
  end

  def oauth_client
    options = {
      :site => 'https://connect.stripe.com',
      :authorize_url => '/oauth/authorize',
      :token_url => '/oauth/token'
    }
    
    @client ||= OAuth2::Client.new(ENV["STRIPE_CLIENT_ID"], ENV["STRIPE_API_KEY"], options)
  end

end
