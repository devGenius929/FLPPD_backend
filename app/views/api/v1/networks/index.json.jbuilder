json.array! (@list_friends) do |user|
  json.user do
    json.partial!('api/v1/users/user', user: user)
  end
  json.mutualFriends user.common_friends_with(user.id)
end
