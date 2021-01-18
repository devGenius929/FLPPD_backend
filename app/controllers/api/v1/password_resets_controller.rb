class Api::V1::PasswordResetsController < Api::V1::BaseController
  include Swagger::Blocks
  skip_before_action :authenticate_request, only: [:create, :update]

  swagger_path '/password_resets/:code' do
    operation :put do
      key :summary, 'restore password'
      parameter do
        key :name, :code
        key :paramType, :path
        key :type, :string
        key :description, 'verification code'
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
  swagger_path '/recover' do
    operation :post do
      key :summary, 'send recover password'
      parameter do
        key :name, :phone_number
        key :in, :formData
        key :type, :string
        key :description, 'Phone number'
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
  def create
    user = User.find_by(phone_number: params[:phone_number])

    if user
      user.send_sms_reset
      render json: {message: "SMS sent to your phone number "+user.phone_number+" with password reset code."}
    else
      render json: { error: "User not found" }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by_password_reset_token(params[:id])

    if @user
      if @user.password_reset_sent_at < 2.hours.ago
        render json: { message: "Password reset has expired." }
      elsif @user.update_attributes(user_params)
        #redirect_to root_url, :notice => "Password has been reset!"
        @user.after_reseted_pass
        render json: { message: "Your information was updated" }
      else
        render json: { message: "error" }, status: :unprocessable_entity
      end
    else
      render json: { message: "Wrong pin" }, status: :unprocessable_entity
    end

  end

  private

    def user_params
      params.require(:user).permit(:phone_number, :password)
    end
end
