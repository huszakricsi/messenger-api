class MessagesChannel < ApplicationCable::Channel
  def subscribed
    stream_for "Chatroom@"+params['conversation']['id'].to_s
    chatroom = Chatroom.find(params['conversation']['id'])
    MessagesChannel.broadcast_to("Chatroom@"+params['conversation']['id'].to_s, {users: chatroom.users, messages: chatroom.messages})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  
  def receive(content)
    chatroom = Chatroom.find(content['conversation']['id'])
    message = Message.new
    message.content = content['message']
    message.user=current_user
    message.save
    chatroom.messages.push(message);
    chatroom.save
    chatroom.reload
    MessagesChannel.broadcast_to("Chatroom@"+content['conversation']['id'].to_s, {users: chatroom.users, messages: chatroom.messages})
  end
end
