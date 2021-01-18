class Api::V1::ServicesController < Api::V1::BaseController
  include Swagger::Blocks
  skip_before_action :authenticate_request

  swagger_path '/ping' do
    operation :get do
      key :summary, 'send push ping'
      response 200 do
        schema do
          property :message do
            key :type, :string
          end
        end
      end
    end
  end

  def ping
    ap FCMService.ping
    render json: { message: 'pong' }
  end

  def cfg
    render json: {
        filestack_app_secrect: ENV['FILESTACK_APP_SECRET'],
        filestack_api_key: ENV['FILESTACK_API_KEY'],
        pubnub_publish_key: ENV['PUBNUB_PUBLISH_KEY'],
        pubnub_subscribe_key: ENV['PUBNUB_SUBSCRIBE_KEY']
    }
  end
end
