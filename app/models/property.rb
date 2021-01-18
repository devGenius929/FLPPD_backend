## Property class
class Property < ApplicationRecord
  include Swagger::Blocks
  # :number_unit, :year_built, :rental_rating, :parking, :lot_size, :zoning, :PropertyListing_id, :defaultimage, :PropertyType_id, :photo_data
  swagger_schema :property do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :price do
      key :type, :string
    end
    property :arv do
      key :type, :string
    end
    property :street do
      key :type, :string
    end
    property :city do
      key :type, :string
    end
    property :state do
      key :type, :string
    end
    property :zip_code do
      key :type, :string
    end
    property :nbeds do
      key :type, :string
    end
    property :nbath do
      key :type, :string
    end
    property :description do
      key :type, :string
    end
    property :sqft do
      key :type, :string
    end
    property :property_category do
      key :type, :string
    end
  end
  belongs_to :user
  belongs_to :PropertyType
  belongs_to :PropertyListing, class_name: "Propertylisting"
  has_many :PropertyImages, dependent: :destroy
  geocoded_by :full_street_address do |obj,results|
    if geo = results.first
      obj.street = geo.street_address
      obj.city = geo.city
      obj.state = geo.state
      obj.zip_code = geo.postal_code
      obj.latitude = geo.latitude
      obj.longitude = geo.longitude
    else
      obj.latitude = nil
      obj.longitude = nil
    end
  end
  before_validation :geocode

  scope :platinum, -> { order(PropertyListing_id: :desc) }
  scope :recent, -> { order(created_at: :desc) }

  validates_presence_of :latitude,:longitude,:message => "Invalid address!"
  validates_uniqueness_of :latitude, scope: :longitude,:message => "This property has already been listed!"
  
  attr_accessor :photo_data

  def full_street_address
    "#{street}, #{city}, #{state}, #{zip_code}"
  end

end
