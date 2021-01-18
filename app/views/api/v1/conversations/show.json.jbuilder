json.mail_messages(@conversation) do |conversation|
	json.body							conversation.message.body
	json.sender							User.find(conversation.message.sender_id).fullname
	json.created_at						conversation.message.conversation.created_at.strftime("%m/%d/%Y %H:%M")
end