require File.expand_path('../concerns/swagger.rb', __FILE__)

class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'FLPPD backend api doc'
      key :description, 'api doc'
      key :termsOfService, 'http://helloreverb.com/terms/'
      contact do
        key :name, 'Johnny'
      end
      license do
        key :name, 'MIT'
      end
    end
    key :host, 'flppdappdev.com'
    # key :host, '0.0.0.0:3000'
    key :basePath, '/api/v1'
    key :consumes, ['application/json']
    key :produces, ['application/json']
    security_definition :jwt do
      key :type, :apiKey
      key :name, :Authorization
      key :in, :header
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
      Api::V1::BaseController,
      Api::V1::AuthenticationController,
      Api::V1::UsersController,
      Api::V1::PasswordResetsController,
      Api::V1::ServicesController,
      Api::V1::MessagesController,
      Api::V1::PropertyImagesController,
      Api::V1::PropertiesController,
      Api::V1::PaymentsController,
      Api::V1::NetworksController,
      Api::V1::ConversationsController,
      User,
      Device,
      ErrorModel,
      PropertyImage,
      Property,
      Network,
      self,
  ].freeze

  def index
    swagger_data = Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
    File.open('lib/swagger/api-docs.json', 'w') { |file| file.write(swagger_data.to_json) }

    render json: swagger_data
  end
end
