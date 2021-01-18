class Api::V1::ConversationsController < Api::V1::BaseController
	include Swagger::Blocks

	swagger_path '/conversations' do
		operation :post do
			key :summary, 'Create conversation'
			parameter do
				key :name, 'mail[user_id]'
				key :in, :formData
				key :type, :string
				key :description, 'user id'
      end
			parameter do
				key :name, 'mail[subject]'
				key :in, :formData
				key :type, :string
				key :description, 'subject'
      end
			parameter do
				key :name, 'mail[body]'
				key :in, :formData
				key :type, :string
				key :description, 'body'
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
				key :description, 'List of conversations'
				# schema do
				# 	key :'$ref', :network
				# end
			end
		end
  end

	swagger_path '/conversations/{id}' do
		operation :get do
			key :summary, 'retrieve conversation'
			parameter do
				key :name, :id
				key :in, :path
				key :type, :string
				key :description, 'id'
      end
			response 200 do
				key :description, 'List of conversations'
			end
		end
  end
	swagger_path '/conversations/{id}/respond' do
		operation :post do
			key :summary, 'post conversation'
			parameter do
				key :name, :id
				key :in, :path
				key :type, :string
				key :description, 'id'
      end
			parameter do
				key :name, :message
				key :in, :formData
				key :type, :string
				key :description, 'message'
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

	##Get all conversations from current user
	def index
		puts(getAllFriendsConversation)
		@conversations = current_user.mailbox.conversations
		@current_user = current_user
	end


	##Get all messages from one conversation
	def show
		@conversation = current_user.mailbox.conversations.find(params[:id]).receipts_for(current_user)
	end

	##Create new conversation with another user
	def create
		mail = params[:mail]
		unless(getAllFriendsConversation.include? mail[:user_id])
			receiver_user = User.find(mail[:user_id])
			current_user.send_message(receiver_user, mail[:body], mail[:subject])
			render json: { message: "Sent message to "+receiver_user.fullname  }
		else
			render json: { message: "You already have one conversation with this user" }, status: :not_acceptable
		end
	end

	##Send message to one conversation
	def respond
		conversation = current_user.mailbox.conversations.find(params[:id])
		if current_user.reply_to_conversation(conversation, params[:message])
			render json: { message: "Replied conversation"}
		else
			render json: { message: "Could not send message"}, status: :bad_request
		end
	end

	private 
	
	def getAllFriendsConversation
		friends_id = []
		current_user.mailbox.conversations.each do |conversation|
			friends_id << current_user.getConversationFriend(conversation.receipts.first).id
		end
		friends_id
	end

end