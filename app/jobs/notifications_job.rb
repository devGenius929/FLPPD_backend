class NotificationsJob < ApplicationJob
	queue_as :default

  	## Send notifications to Android and ios, How call this method?, for Example:
  	#notification = {body: "this is the body", title: "Hail the king of the North!", icon: "myicon" }
  	#send_push_notification("ezF66GvoKFw:APA91bFSGwI2Fd6hv9SfPxn8Q3Xzgba0XLq4e-GtS9EHykwO__JmiX_e0KSMSPdP34nsNswjQM3T0zJW1Ewprjhf1rIroHWeJsAEIsks3m8B7oklaCi1ONDLjBAoBXJ4OepaWXLWE_uE", json_request)
  	def send_push_notification(to, notification)
      	json_request = { to: to, notification: notification }.to_json
      	request= RestClient::Request.execute(
        	method: :post, 
        	url: ENV["FCM_URL"], 
        	:headers => { 
          		'Content-Type' => 'application/json',
          		'Accept' => 'application/json', 
          		'Authorization' => 'key='+ENV["FIREBASE_SERVER_KEY"]
        	},
        	payload: json_request
      	)
    	json_for_log = { to: Device.where(device_token: to ).last.user.username ,request: json_request, response: request  }.to_json
    	Logger.new("#{Rails.root}/log/notifications.log").info(json_for_log)
  	end
 
end
