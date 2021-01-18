json.mails_count						@conversations.count
json.mails(@conversations) do |conversation|
	json.id 							conversation.id
	json.subject						conversation.subject
	json.sender							User.find(conversation.receipts.first.message.sender_id).fullname
	json.receiver						User.find(conversation.receipts.first.receiver_id).fullname
	json.friend							@current_user.getConversationFriend(conversation.receipts.first).fullname
	json.created_at						conversation.created_at.strftime("%m/%d/%Y %H:%M")
end