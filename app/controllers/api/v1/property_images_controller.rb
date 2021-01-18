class Api::V1::PropertyImagesController < Api::V1::BaseController
  include Swagger::Blocks
  #before_action :subscription_filter
  before_action :set_property_image, only: [:show, :update, :destroy]
  # this Model doesnt allow to show index or update

  swagger_path '/property_images' do
    operation :post do
      key :summary, 'Verify user by sms'
      parameter do
        key :name, 'property_image[image_url]'
        key :in, :formData
        key :type, :string
        key :description, 'phone number'
      end
      parameter do
        key :name, 'property_image[property_id]'
        key :in, :formData
        key :type, :integer
        key :description, 'property_id'
      end
      response 200 do
        schema do
          key :'$ref', :property_image
        end
      end
    end
  end
  swagger_path '/property_images/{id}' do
    operation :get do
      parameter do
        key :name, :id
        key :paramType, :path
        key :in, :path
        key :type, :integer
        key :description, 'id'
      end
      response 200 do
        schema do
          key :'$ref', :property_image
        end
      end
    end
    operation :delete do
      parameter do
        key :name, :id
        key :paramType, :path
        key :in, :path
        key :type, :integer
        key :description, 'id'
      end
      response 200 do
      end
    end
  end

  # GET /property_images
  def index
    @property_images = PropertyImage.all

    render json: @property_images
  end

  # GET /property_images/1
  def show
    render json: @property_image
  end

  # POST /property_images
  def create
    @property_image = PropertyImage.new(property_image_params)

    if @property_image.save
      render json: @property_image, status: :created, location: '/property_images'
    else
      render json: @property_image.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /property_images/1
  def update
    if @property_image.update(property_image_params)
      render json: @property_image
    else
      render json: @property_image.errors, status: :unprocessable_entity
    end
  end

  # DELETE /property_images/1
  def destroy
    @property_image.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property_image
      @property_image = PropertyImage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def property_image_params
      params.require(:property_image).permit(:image_url, :property_id)
    end
end
