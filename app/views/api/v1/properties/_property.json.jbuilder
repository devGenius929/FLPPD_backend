json.extract! property, :id, :price, :arv, :street, :city, :state, :zip_code, :nbeds, :nbath, :description, :sqft, :property_category, :number_unit, :year_built, :parking, :lot_size, :zoning, :rental_rating, :created_at, :updated_at, :latitude, :longitude, :rehab_cost

json.price_currency number_to_currency(property.price, precision: 0)
json.arv_currency number_to_currency(property.arv, precision: 0)
json.price_to_human number_to_human(property.price, :format => '%n%u', :precision => 2, :units => { :thousand => 'K', :million => 'M', :billion => 'B' })
json.arv_to_human number_to_human(property.arv, :format => '%n%u', :precision => 2, :units => { :thousand => 'K', :million => 'M', :billion => 'B' })
json.property_type property.PropertyType.ptype
json.property_type_id property.PropertyType.id
json.property_listing_id property.PropertyListing ? property.PropertyListing.id : 0
json.property_listing_type property.PropertyListing ? property.PropertyListing.pl_name : 0
json.created_at_in_words time_ago_in_words(property.created_at)
json.pubDate property.created_at.strftime("%I:%M %p, %b %d %Y")

json.default_img property.defaultimage
json.default_img_thumb property.defaultimage
json.default_img_thumb_port property.defaultimage

json.starred @starred_items.include?(property.id) if @starred_items
json.user do
  json.user_id      property.user.id
  json.first_name   property.user.first_name
  json.last_name    property.user.last_name
  json.avatar       property.user.avatar
  json.email        property.user.email
  json.about        property.user.about
  json.phone_number property.user.phone_number
  json.created_at		property.user.created_at.strftime("%b, %Y")
  json.friend       @network ? true : false
end

json.photos property.PropertyImages do |attachment|
  json.id attachment.id
  json.image attachment.image_url
end

# photoArray = Array.new
# property.PropertyImages.each do |i|
#   photoArray << i.image_url.url
# end
#
# json.photos do
#   json.array!  photoArray
# end

