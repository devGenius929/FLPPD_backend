json.auth_token						@token if @token
json.user_id						@user.id
json.first_name						@user.first_name
json.last_name						@user.last_name
json.phone_number					@user.phone_number
json.email							  @user.email
json.about                @user.about
json.created_at						@user.created_at.strftime("%b, %Y")
json.activated						@user.activated
json.activated_at					@user.activated_at
json.avatar							  @user.avatar
json.verified						  @user.verified
json.customer_id					@user.customer_id
json.subscribed						@user.subscribed?
json.friend               @network ? true : false
json.firebase_password    @user.firebase_password
json.role                 @user.role
json.city                 @user.city
json.state                @user.state
json.areas                @user.areas
json.rank                 @user.rank
json.hauses_sold          @user.hauses_sold
json.is_new               @is_new if @is_new
if(@user.subscribed?)
	json.subscription_id 			    @user.subscriptions[0].id
	json.subscription_name 			  @user.subscriptions[0].plan.name
	json.subscription_expiration	Time.at(@user.subscriptions[0].current_period_end).to_datetime.strftime("%m/%d/%Y")
	json.subscription_active		  @user.subscribtion_active?
	json.subscription_status		  @user.subscriptions[0].status
	json.trial_end					      Time.at(@user.subscriptions[0].trial_end).to_datetime.strftime("%m/%d/%Y")	if @user.subscriptions[0].trial_end
	json.cancelled					      @user.subscription_cancelled?
	#json.canceled_at     			  Time.at(@user.subscriptions[0].canceled_at).to_datetime.strftime("%m/%d/%Y") if @user.subscription_cancelled?
end