class MailchimpIntegration < Integration

  validates_presence_of :api_key, :on=>:create
  validates_presence_of :default_list, :on=>:update

  validate :connection_valid, on: :create
  
  def connection_valid
    if api_key
      @gb = get_connection
      begin
        lists = @gb.lists.list
      rescue Exception => e
        Rails.logger.info("MailChimp Exception: #{e}")
        errors.add(:api_key, "appears to be invalid.")
      end
    end
  end

  attr_accessor :export_list
  attr_accessor :import_list

  def default_list
    settings['default_list']
  end

  def default_list=(list_id)
    settings['default_list'] = list_id
  end

  def available_lists
    lists = []

    with_connection do |gb|
      data = gb.lists.list['data']
      lists = data.collect {|h| [ h["name"],h["id"] ]}
    end

    lists
  end

  def configured?
    connected? && settings.has_key?("default_list")
  end

  def user_added(user)
    subscribe_user(user, default_list)
  end

  def user_updated(user)
    subscribe_user(user, default_list)
  end


  protected 
  def subscribe_user(user, list)
    return with_connection do |gb|
      subscribed = user.integration_data[:mailchimp] == list
      
      gb.lists.subscribe({:id => list, 
                           :email => {:email => user.email}, 
                           :merge_vars => {
                             :FNAME => user.first_name, 
                             :LNAME => user.last_name, 
                             :MTYPE => user.member_type.name,
                             :MSTATUS => user.status,
                           }, 
                           :update_existing => subscribed,
                           :double_optin => false})

      unless subscribed
        user.integration_data[:mailchimp] = list
        user.skip_user_updated = true         # Prevent endless loop of callback calling
        user.save      
      end

      true
    end
  end

  def get_connection()
    @gb ||= Gibbon::API.new(api_key)
  end

  def with_connection(&block)

    if connected?
      begin

        @gb = get_connection
        
        result = yield @gb

      rescue Exception => e
        Rails.logger.info("MailChimp Exception: #{e}")
        result = false
      end
    end

    return result
  end

end
