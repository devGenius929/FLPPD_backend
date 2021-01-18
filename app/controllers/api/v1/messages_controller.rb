class Api::V1::MessagesController < Api::V1::BaseController
  include Swagger::Blocks

  swagger_path '/messages/:user_id' do
    operation :post do
      key :summary, 'send message to user'
      parameter do
        key :name, :user_id
        # key :in, :formData
        key :paramType, :path
        key :type, :integer
        key :description, 'id of user'
      end
      parameter do
        key :name, :message
        key :in, :formData
        key :type, :string
        key :description, 'text'
      end
      response 200 do
        schema do
          property :status do
            key :type, :string
          end
        end
      end
    end
  end

  def create
    user = User.find(params[:user_id])
    return api_error(status: 422, errors: 'no user') unless user

    unless params[:message]
      return api_error(status: 422, errors: 'no data to send')
    end
    FCMService.new(user.devices.map(&:device_token), params[:message]).call

    render json: { status: 'sent' }
  end
end
