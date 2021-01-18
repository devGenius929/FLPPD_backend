class Api::V1::NetworksController < Api::V1::BaseController
	include Swagger::Blocks

  swagger_path '/network' do
    operation :post do
      key :summary, 'Create network'
      parameter do
        key :name, :user_id
        key :in, :formData
        key :type, :string
        key :description, 'friend id'
      end
      response 200 do
        schema do
          property :message do
            key :type, :string
          end
        end
      end
    end
    operation :get do
      key :summary, 'Get list of '
      response 200 do
        key :description, 'Network objects'
        schema do
          key :'$ref', :network
        end
      end
    end
  end

  swagger_path '/network/{id}/accept' do
    operation :put do
      key :summary, 'accept network'
      parameter do
        key :name, :id
        key :in, :path
        key :type, :string
        key :description, 'friend id'
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

  swagger_path '/network/{id}/delete' do
    operation :delete do
      key :summary, 'delete network'
      parameter do
        key :name, :id
        key :in, :path
        key :type, :string
        key :description, 'friend id'
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

  swagger_path '/network/{id}' do
    operation :delete do
      key :summary, 'delete network'
      parameter do
        key :name, :id
        key :in, :path
        key :type, :string
        key :description, 'friend id'
      end
      response 200 do
        schema do
          property :message do
            key :type, :string
          end
        end
      end
    end
    operation :get do
      key :summary, 'Get friends for user'
      parameter do
        key :name, :id
        key :in, :path
        key :type, :string
        key :description, 'user id'
      end
      response 200 do
        schema do
          property :friends do
            key :type, :array
            key :description, 'list of users'
          end
          property :common_friends do
            key :type, :integer
          end
        end
      end
    end
  end

  swagger_path '/pendingconnections' do
    operation :get do
      key :summary, 'get pending connections'
      response 200 do
        key :description, 'list of Network objects'
        schema do
          key :'$ref', :network
        end
      end
    end
  end
  swagger_path '/waitingconnections' do
    operation :get do
      key :summary, 'get waiting connections'
      response 200 do
        key :description, 'list of Network objects'
        schema do
          key :'$ref', :network
        end
      end
    end
  end

	def index
    @common = 0
    if params[:id]
      @user = User.find(params[:id])
      @list_friends = @user.friends
      @common = (@list_friends.map(&:id) & current_user.friends.map(&:id)).length
    else
      @list_friends = current_user.friends
    end
	end

	def create
		@network = Network.new(user_id: current_user.id, friend_id: params[:user_id])
		friend = User.find(params[:user_id])
		if @network.save
			render json: {message: "Your connection request was sent to "+friend.fullname}
      		##render "api/v1/networks/create.json.jbuilder"
		else
      		render json: @network.errors, status: :unprocessable_entity
		end
	end

	##Acept one network connect request
	def acceptConnection
		@network = Network.where(user_id: params[:id], friend_id: current_user.id).first
		user = User.find(params[:id])
		if @network.present? 
			if !@network.status
				if @network.update(status: true)

          #send notification to user device
          message = user.fullname+" has been added to your network"
          FCMService.new(user.devices.map(&:device_token), message).call

					render json: {message: message}, status: :ok
				else
		      render json: @network.errors, status: :unprocessable_entity
				end
			else
				render json: {message: "You and "+user.fullname+" are already friends"}, status: :not_acceptable
			end
		else
	    render json: {error: "Friend Request not found"}, status: :not_found
		end
	end
  
	##reject one network connect request
	def deleteConnection
		@network = Network.where(user_id: params[:id], friend_id: current_user.id).first
		user = User.find(params[:id])
		if @network.present? 
			if !@network.status
				if @network.delete
					render json: { message: "Network request rejected" }, status: :ok
				else
		      		render json: @network.errors, status: :unprocessable_entity
				end
			else
				render json: {message: "You and "+user.fullname+" are already friends"}, status: :not_acceptable
			end
		else
	      	render json: {error: "Friend Request not found"}, status: :not_found
		end
	end

	#This return all the users pending requests for your answer
	def pendingConnectionsRequest
		@list_friends = current_user.pending_friends
    	render "api/v1/networks/index.json.jbuilder"
	end

	#This return all the users connection requests what you are waiting for answer
	def waitingConnectionsRequest
		@list_friends = current_user.requested_friendships      			
		render "api/v1/networks/index.json.jbuilder"
	end

	#This delete some user from your network
	def destroy
		current_user.all_network_request.select do |network|
			if network.user_id == params[:id].to_i || network.friend_id == params[:id].to_i
				network.delete
			end
		end
		render json: { message: "User deleted fron your network" }, status: :ok
	end

end