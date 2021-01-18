class Api::V1::AuthenticationController < Api::V1::BaseController
  include Swagger::Blocks

  skip_before_action :authenticate_request, except: :sync

  swagger_path '/authenticate' do
    operation :post do
      key :summary, 'Creates session for registered user'
      parameter do
        key :name, :email
        key :in, :formData
        key :type, :string
        key :description, 'registered user email'
      end
      parameter do
        key :name, :password
        key :in, :formData
        key :type, :string
        key :description, 'registered user password'
      end
      response 200 do
        key :description, 'User object'
        schema do
          key :'$ref', :user
        end
      end
    end
  end

  swagger_path '/logout' do
    operation :delete do
      key :summary, 'destroy user session and remove devices'
      security do
        key :api_key, []
      end
      response 200 do
        schema do
          property :message do
            key :type, :string
          end
        end
      end
    end
  end

  swagger_path '/apns' do
    operation :post do
      # extend SwaggerResponses::AuthenticationError

      key :summary, 'add device and update token'
      security do
        key :jwt, ['Authorization']
      end
      parameter do
        key :name, :device_id
        key :in, :formData
        key :type, :string
        key :description, 'id of device'
      end
      parameter do
        key :name, :device_token
        key :in, :formData
        key :type, :string
        key :description, 'google token'
      end
      response 200 do
        schema do
          property :message do
            key :type, :string
          end
        end
      end
      # response 401 do
      #   schema do
      #     key :'$ref', :ErrorModel
      #   end
      # end

    end
  end

  def authenticate
    #I skipped the simple command implementation because was too slow
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      @token = JsonWebToken.encode(user_id: @user.id)
      session[:user_id] = @user.id
      @user.check_firebase_password

      render "api/v1/users/show.json.jbuilder"
    else
      render json: { error: 'invalid credentials' }, status: :unauthorized
    end
  end

  def logout
    destroy_session
    device.destroy if device.present?

    render json: { message: 'session deleted' }
  end

  def sync
    msg = 'success'
    if params[:device_token].blank?
      msg = 'no device token'
    elsif params[:device_id].blank?
      msg = 'no device id'
    else
      add_user_device
    end

    render json: { message: msg }
  end

  private

  def add_user_device
    if device
      device.update(user: current_user, device_token: params[:device_token])
    else
      current_user.devices.create(device_id: params[:device_id], device_token: params[:device_token])
    end
  end

  def device
    @device ||= Device.find_by(device_id: params[:device_id])
  end
end