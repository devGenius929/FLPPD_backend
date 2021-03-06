json.user_id              user.id
json.first_name						user.first_name
json.last_name						user.last_name
json.phone_number					user.phone_number
json.email							  user.email
json.about                 user.about
json.created_at						user.created_at.strftime("%b, %Y")
json.avatar							  user.avatar
json.role                 user.role
json.city                 user.city
json.state                user.state
json.areas                user.areas
json.rank                 user.rank
json.hauses_sold          user.hauses_sold
json.devices user.devices do |device|
  json.device_id device.device_id
  json.token device.device_token
end