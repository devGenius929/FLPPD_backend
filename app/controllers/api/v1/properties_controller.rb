class Api::V1::PropertiesController < Api::V1::BaseController
  include Swagger::Blocks
  #before_action :subscription_filter, except: [:index, :show]
  before_action :set_property, only: [:show, :update, :destroy]

  swagger_path '/properties' do
    operation :post do
      key :summary, 'Create new object'
      parameter do
        key :name, 'property[price]'
        key :in, :formData
        key :type, :integer
        key :description, 'price'
      end
      parameter do
        key :name, 'property[arv]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[street]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[city]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[state]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[zip_code]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[nbeds]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[nbath]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[description]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[sqft]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[property_category]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[number_unit]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[year_built]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[rental_rating]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
        end
      parameter do
        key :name, 'property[parking]'
        key :in, :formData
        key :type, :string
        key :description, '??'
        end
      parameter do
        key :name, 'property[lot_size]'
        key :in, :formData
        key :type, :string
        key :description, '??'
        end
      parameter do
        key :name, 'property[zoning]'
        key :in, :formData
        key :type, :string
        key :description, '??'
        end
      parameter do
        key :name, 'property[PropertyListing_id]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[defaultimage]'
        key :in, :formData
        key :type, :string
        key :description, 'link to image'
        end
      parameter do
        key :name, 'property[PropertyType_id]'
        key :in, :formData
        key :type, :string
        key :description, '??'
        end
      parameter do
        key :name, 'property[photo_data]'
        key :in, :formData
        key :type, :string
        key :description, 'link, link2, link3'
      end
      parameter do
        key :name, 'property[rehab_cost]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      response 200 do
        schema do
          key :'$ref', :property
        end
      end
    end
    operation :get do
      parameter do
        key :name, :user_id
        key :paramType, :query
        key :in, :query
        key :type, :integer
        key :description, 'user id'
      end
      parameter do
        key :name, :limit
        key :paramType, :query
        key :in, :query
        key :type, :integer
        key :description, 'positive integer'
      end
      parameter do
        key :name, :city
        key :paramType, :query
        key :in, :query
        key :type, :integer
        key :description, 'string, case insensetive'
      end
      parameter do
        key :name, :state
        key :paramType, :query
        key :in, :query
        key :type, :integer
        key :description, 'full state name, case insensetive'
      end
      parameter do
        key :name, :zipcode
        key :paramType, :query
        key :in, :query
        key :type, :integer
        key :description, 'positive integer'
      end
      parameter do
        key :name, :price_min
        key :paramType, :query
        key :in, :query
        key :type, :integer
        key :description, 'positive integer'
      end
      parameter do
        key :name, :price_max
        key :paramType, :query
        key :in, :query
        key :type, :integer
        key :description, 'positive integer'
      end
      parameter do
        key :name, :type
        key :paramType, :query
        key :in, :query
        key :type, :integer
        key :description, 'string, Flip or rental, case insensetive'
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :property
          end
        end
      end
    end
  end
  swagger_path '/properties/{id}' do
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
          key :'$ref', :property
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
    operation :put do
      parameter do
        key :name, :id
        key :paramType, :path
        key :in, :path
        key :type, :integer
        key :description, 'id'
      end
      parameter do
        key :name, 'property[price]'
        key :in, :formData
        key :type, :integer
        key :description, 'price'
      end
      parameter do
        key :name, 'property[arv]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[street]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[city]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[state]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[zip_code]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[nbeds]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[nbath]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[description]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[sqft]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[property_category]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[number_unit]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[year_built]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[rental_rating]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      parameter do
        key :name, 'property[parking]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[lot_size]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[zoning]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[PropertyListing_id]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[defaultimage]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[PropertyType_id]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[photo_data]'
        key :in, :formData
        key :type, :string
        key :description, '??'
      end
      parameter do
        key :name, 'property[rehab_cost]'
        key :in, :formData
        key :type, :integer
        key :description, '??'
      end
      response 200 do
      end
    end
  end

  include ActionController::ImplicitRender
  include ActionController::MimeResponds
  # GET /properties
  def index
    user_id = params[:user_id]
    limit = params[:limit] ? params[:limit].to_i : 20
    ordered_properties = Property.platinum.recent.limit(limit)

    if user_id.present?
      ordered_properties = ordered_properties.where(user_id: user_id)
      @network = Network.where(user_id: user_id, friend_id: current_user.id).first
      @network ||= Network.where(user_id: current_user.id, friend_id: user_id).first
    end
    if params[:city] && !params[:city].blank?
      ordered_properties = ordered_properties.where('lower(city) = ?', params[:city].downcase)
    end
    if params[:state] && !params[:state].blank?
      ordered_properties = ordered_properties.where('lower(state) = ?', params[:state].downcase)
    end
    if params[:zipcode] && !params[:zipcode].blank?
      ordered_properties = ordered_properties.where('zip_code = ?', params[:zipcode])
    end
    if params[:price_min] && !params[:price_min].blank?
      ordered_properties = ordered_properties.where('price >= ?', params[:price_min])
    end
    if params[:price_max] && !params[:price_max].blank?
      ordered_properties = ordered_properties.where('price <= ?', params[:price_max])
    end
    if params[:type] && !params[:type].blank?
      ptype = PropertyType.where('lower(ptype) LIKE ?', "%#{params[:type].downcase}%").first
      type_id = ptype ? ptype.id : nil
      ordered_properties = ordered_properties.where(PropertyType_id: type_id)
    end

    @properties = ordered_properties
    @starred_items = current_user.favorites
  end

  # GET /properties/1
  def show
    @property_images = @property.PropertyImages.all
    @starred_items = current_user.favorites
  end

  # POST /properties
  def create
    @property = Property.new(property_params)
    @property.user_id = current_user.id
    if @property.save

      photos = params[:property][:photo_data]
      if photos
        photos.split(',').each do |p|
          @property.PropertyImages.create!(image_url: p)
        end
      end

      render :show, status: :created, location: '/properties'
    else
      render json: @property.errors.full_messages.first, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /properties/1
  def update
    if @property.update(property_params)

      photos = params[:property][:photo_data]
      saved_photos = @property.PropertyImages.all
      saved_photos_url_array = []

      if saved_photos
        saved_photos.each do |saved_photo|
          saved_photos_url_array.append(saved_photo.image_url.strip)
        end
      end

      saved_photos_url_string = saved_photos_url_array.join(', ')

      if photos != saved_photos_url_string
        @property.PropertyImages.destroy_all

        photos.split(',').each do |p|
          @property.PropertyImages.create!(image_url: p.strip)
        end
      end

      render :show, status: :created, location: '/properties'
    else
      render json: @property.errors.first[1], status: :unprocessable_entity
    end
  end

  # DELETE /properties/1
  def destroy
    @property.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def property_params
      params.require(:property).permit(:price, :arv, :street, :city, :state, :zip_code, :nbeds, :nbath, :description, :sqft, :property_category, :number_unit, :year_built, :rental_rating, :parking, :lot_size, :zoning, :PropertyListing_id, :defaultimage, :PropertyType_id, :rehab_cost, :photo_data => [])
    end
end


