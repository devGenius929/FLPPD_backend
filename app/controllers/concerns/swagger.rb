module SwaggerResponses
  module AuthenticationError
    def self.extended(base)
      base.response 401 do
        key :description, 'not authorized'
        schema do
          key :'$ref', :AuthenticationError
        end
      end
    end
  end
end
class ErrorModel  # Notice, this is just a plain ruby object.
  include Swagger::Blocks

  swagger_schema :ErrorModel do
    key :required, [:code, :message]
    property :code do
      key :type, :integer
      key :format, :int32
    end
    property :message do
      key :type, :string
    end
  end
end