class Device < ApplicationRecord
  include Swagger::Blocks
  swagger_schema :device do
    property :device_token do
      key :type, :string
    end
    property :device_id do
      key :type, :string
    end
  end
  belongs_to :user
end
