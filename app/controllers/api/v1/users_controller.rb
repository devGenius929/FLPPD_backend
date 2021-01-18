class Api::V1::UsersController < Api::V1::BaseController
  include Swagger::Blocks
  skip_before_action :authenticate_request, only: [:create, :verify, :generate_pin, :facebook_auth]

  swagger_path '/signup' do
    operation :post do
      key :summary, 'Create user'
      parameter do
        key :name, 'user[email]'
        key :in, :formData
        key :type, :string
        key :description, 'registered user email'
      end
      parameter do
        key :name, 'user[password]'
        key :in, :formData
        key :type, :string
        key :description, 'registered user password'
      end
      parameter do
        key :name, 'user[first_name]'
        key :in, :formData
        key :type, :string
        key :description, 'Name'
      end
      parameter do
        key :name, 'user[last_name]'
        key :in, :formData
        key :type, :string
        key :description, 'name'
      end
      parameter do
        key :name, 'user[phone_number]'
        key :in, :formData
        key :type, :string
        key :description, 'phone'
      end
      parameter do
        key :name, 'user[about]'
        key :in, :formData
        key :type, :string
        key :description, 'some text'
      end
      response 200 do
        key :description, 'User object'
        schema do
          key :'$ref', :user
        end
      end
    end
  end
  swagger_path '/facebook_auth' do
    operation :post do
      key :summary, 'Login through Facebook'
      parameter do
        key :name, 'access_token'
        key :in, :formData
        key :type, :string
        key :description, 'token from facebook'
      end
      response 200 do
        key :description, 'User object'
        schema do
          key :'$ref', :user
        end
      end
    end
  end

  swagger_path '/verify' do
    operation :post do
      key :summary, 'Verify user by sms'
      parameter do
        key :name, :phone_number
        key :in, :formData
        key :type, :string
        key :description, 'phone number'
      end
      parameter do
        key :name, :pin
        key :in, :formData
        key :type, :string
        key :description, '4 numbers'
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
  swagger_path '/generate' do
    operation :post do
      key :summary, 'Verify user by sms'
      parameter do
        key :name, :phone_number
        key :in, :formData
        key :type, :string
        key :description, 'phone number'
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
  swagger_path '/search/users' do
    operation :get do
      key :summary, 'Search users'
      parameter do
        key :name, :search
        # key :in, :formData
        key :paramType, :query
        key :type, :string
        key :description, 'some string'
      end
      response 200 do
        key :description, 'User objects'
        schema do
          key :'$ref', :user
        end
      end
    end
  end
  swagger_path '/users/{id}/profile' do
    operation :get do
      key :summary, 'user profile'
      parameter do
        key :name, :id
        key :paramType, :path
        key :in, :path
        key :type, :integer
        key :description, 'some string'
      end
      response 200 do
        key :description, 'User objects'
        schema do
          key :'$ref', :user
        end
      end
    end
    operation :put do
      key :summary, 'update user profile'
      parameter do
        key :name, :id
        key :paramType, :path
        key :in, :path
        key :type, :integer
        key :description, 'some string'
      end
      parameter do
        key :name, 'user[first_name]'
        key :in, :formData
        key :type, :string
        key :description, 'Name'
      end
      parameter do
        key :name, 'user[last_name]'
        key :in, :formData
        key :type, :string
        key :description, 'name'
      end
      parameter do
        key :name, 'user[phone_number]'
        key :in, :formData
        key :type, :string
        key :description, 'phone'
      end
      parameter do
        key :name, 'user[about]'
        key :in, :formData
        key :type, :string
        key :description, 'some text'
      end
      parameter do
        key :name, 'user[avatar]'
        key :in, :formData
        key :type, :string
        key :description, 'link to picture'
      end
      parameter do
        key :name, 'user[city]'
        key :in, :formData
        key :type, :string
        key :description, 'city'
      end
      parameter do
        key :name, 'user[state]'
        key :in, :formData
        key :type, :string
        key :description, 'state'
      end
      parameter do
        key :name, 'user[areas]'
        key :in, :formData
        key :type, :string
        key :description, 'string by comma'
      end
      response 200 do
        key :description, 'User objects'
        schema do
          key :'$ref', :user
        end
      end
    end
  end

  swagger_path '/favorites' do
    operation :get do
      response 200 do
        key :description, 'List of projects'
        schema do
          key :type, :array
          items do
            key :'$ref', :property
          end
        end
      end
    end
  end

  swagger_path '/favorites/:id' do
    operation :post do
      key :description, 'Add property to saved'
      parameter do
        key :name, :id
        key :paramType, :path
        key :in, :path
        key :type, :integer
        key :description, 'property id'
      end
      response 200 do
        schema do
          property :message do
            key :type, :string
          end
        end
      end
    end
    operation :delete do
      key :description, 'Delete property from saved'
      parameter do
        key :name, :id
        key :paramType, :path
        key :in, :path
        key :type, :integer
        key :description, 'property id'
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

  def show
    @user = User.find(params[:id])
    @network = Network.where(user_id: params[:id], friend_id: current_user.id).first
    
    if !@network
      @network = Network.where(user_id: current_user.id, friend_id: params[:id]).first
    end
    
    render "api/v1/users/show.json.jbuilder"
  end

  def index
    @users = User.all
    render "api/v1/users/index.json.jbuilder"
  end

  def profile
    @user = User.find(params[:id])
    render "api/v1/users/profile.json.jbuilder"
  end
  
  def search
    @users = User.search(params[:search])
    render "api/v1/users/index.json.jbuilder"
  end

  def create
    @user = User.new(create_params)
    return api_error(status: 422, errors: @user.errors) unless @user.valid?

    @user.save!
    @user.generate_pin
    @user.send_pin
    @user.check_firebase_password

    UserMailer.confirm_email(@user).deliver
    @token = JsonWebToken.encode(user_id: @user.id)

    render "api/v1/users/show.json.jbuilder"
  rescue => e
    ap e
    if e.code == 21211
      User.delete(@user.id)
      return api_error(status: 422, errors: 'Invalid phone number')
    end
    return api_error(status: 422, errors: e.message)
  end

  def verify
   user = User.find_by(phone_number: params[:phone_number])
   pin = params[:pin]
   if user
     if user.verified == false
       if user.pin == pin
         user.verify(pin)
         render json: {message:"verified"}
       else
         render json: { error: "Wrong pin" }, status: :unprocessable_entity
       end
     else
       render json: {error: "user already verified"}, status: :unprocessable_entity
     end
   else
     render json: {error: "User not found"}, status: :unprocessable_entity
    end
  end

  def generate_pin
    user = User.find_by(phone_number: params[:phone_number])
    if user
      user.generate_pin
      user.send_pin
      render json: { message: "New pin sent" }
    else
      render json: { error: "User not found" }, status: :unprocessable_entity
    end
  end

  def update
    unless params[:id].to_i == current_user.id
      render(json: { error: "You don't have rights" }, status: :unprocessable_entity) && return
    end
    @user = User.find(params[:id])
    if @user
      if @user.update(create_params)
        render 'api/v1/users/profile.json.jbuilder'
      else
        return api_error(status: 422, errors: @user.errors)
      end
    end
  rescue => e
    return api_error(status: 422, errors: e.message)
  end

  def favorites
    @properties = Property.where(id: current_user.favorites)

    render 'api/v1/properties/index.json.jbuilder'
  end

  def add_favorite
    if current_user.update_attribute(:favorites, (current_user.favorites || []) + [params[:property_id]])
      render json: { message: 'saved' }
    else
      return api_error(status: 422, errors: current_user.errors)
    end
  end

  def remove_favorite
    to_save = current_user.favorites || []
    to_save.delete(params[:property_id].to_i)

    if to_save == current_user.favorites || current_user.update_attribute(:favorites, to_save)
      render json: { message: 'removed' }
    else
      return api_error(status: 422, errors: current_user.errors)
    end
  end

  def facebook_auth
    raise('No access token given') unless params[:access_token]
    @graph = Koala::Facebook::API.new(params[:access_token])

    profile = @graph.get_object('me', fields: 'email,first_name,last_name')

    @user = User.find_by(email: profile['email'])
    @is_new = false

    unless @user
      pwd = SecureRandom.hex(3).upcase
      @user = User.new(
        email: profile['email'],
        first_name: profile['first_name'],
        last_name: profile['last_name'],
        password: pwd,
        password_confirmation: pwd
      )
      @user.save(validate: false)
      @is_new = true
    end
    UserMailer.confirm_email(@user).deliver if @is_new
    @token = JsonWebToken.encode(user_id: @user.id)

    render "api/v1/users/show.json.jbuilder"
  rescue => e
    if profile['email'].blank?
      return render json: { error: 'facebook: no access to email' }, status: 422
    elsif !@user.valid?
      return api_error(status: 422, errors: @user.errors)
    end
    render json: { status: 422, errors: e.message }
  end

  private

  def create_params
    params.require(:user)
        .permit(:email, :password, :first_name, :last_name, :phone_number, :about, :avatar, :city, :state, :areas, :role)
  end
end
