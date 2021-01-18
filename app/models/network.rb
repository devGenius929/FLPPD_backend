class Network < ApplicationRecord
	include Swagger::Blocks

	swagger_schema :network do
		property :id do
			key :type, :integer
			key :format, :int64
		end
		property :user_id do
			key :type, :integer
			key :format, :int64
		end
		property :friend_id do
			key :type, :integer
			key :format, :int64
		end
		property :status do
			key :type, :boolean
		end
	end
	belongs_to :user
	belongs_to :friend, class_name: "User"


	validates :user_id, uniqueness: { scope: :friend_id, message: "You already added this user" }
	validate :invalid_request


	before_create :default_value



	def default_value
		self.status = false
	end


	def invalid_request
		if self.user_id==self.friend_id
			self.errors.add(:user_id, "User can't add himself")
		end
	end


end
