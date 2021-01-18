class PropertyImage < ApplicationRecord
  include Swagger::Blocks

  swagger_schema :property_image do
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :image_url do
      key :type, :string
    end
    property :property_id do
      key :type, :integer
    end
  end

  belongs_to :property
end
