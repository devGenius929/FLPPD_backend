require 'fcm'

# FCMService.ping
# FCMService.new_listing_is_added
# FCMService.ask_renew_listing
# FCMService.new_hot_investments
class FCMService
  attr_reader :fcm_client, :message, :user_device_ids

  MAX_USER_IDS_PER_CALL = 1000

  def initialize(user_device_ids, message)
    @fcm_client = FCM.new(ENV['FCM_SERVER_KEY'])
    @user_device_ids = user_device_ids
    @message = message
  end

  def self.ping
    new(all_tokens, 'pong!').call
    # new(tokens, 'pong!').call
  end

  def self.new_listing_is_added
    new(all_tokens, 'new properties available in your preferred area').call
  end

  def self.ask_renew_listing
    new(all_tokens, 'Would you like to renew listing?').call
  end

  def self.new_hot_investments
    new(all_tokens, 'there are some hot new investment properties available! Would you like to upgrade to have access to these properties?').call
  end

  def self.message_to_user(devices, message)
    new(devices, message).call
  end

  def call
    @user_device_ids.each_slice(MAX_USER_IDS_PER_CALL) do |device_ids|
      Rails.logger.info @fcm_client.send(device_ids, options)
    end
  end

  private

  # Alex's token
  def self.tokens
    ['ebGfsMTCDeM:APA91bGtK_h0b8HRB3h9cRJxLzeQmn2nWRebLX9BotM_H9Mq11Rz6JufiJMj961UAICmvT0bFwpRZG8TYy80kWGqUsLIgQGfyWVxt5iXumayfuzXqGID3XMOWJeHFzYst9rlwet0RCd4']
  end

  def self.all_tokens
    Device.all.map(&:device_token)
  end

  def options
    {
      priority: 'high',
      data: {
        message: message
      },
      notification: {
        body: message,
        sound: 'default'
      }
    }
  end
end
