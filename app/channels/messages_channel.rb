class MessagesChannel < ApplicationCable::Channel
  def subscribed
    chatroom = nil
    if(params['type']=="chatroom")
      chatroom = Chatroom.find(params['conversation']['id'])
    elsif(params['type']=="userchat")
      id_other = params["user"]["id"];
      identifier=""
      if(id_other<current_user.id)
        identifier = id_other.to_s+":"+current_user.id.to_s
      else
        identifier = current_user.id.to_s+":"+id_other.to_s
      end
      #when two users chat the chatroom identifier will be lower user id:higher user id
      begin 
        chatroom = Chatroom.find_by!(identifier: identifier)#getting chatroom
      rescue ActiveRecord::RecordNotFound
        chatroom = Chatroom.new
        chatroom.identifier=identifier
        chatroom.save!
        chatroom.users.push(current_user)
        chatroom.users.push(User.find(params["user"]["id"]))
        chatroom.save!
        chatroom.reload
      ensure
          #
      end      
      current_user.reload
      ChatroomsChannel.broadcast_to("ChatroomsChannel", {YourRooms: current_user.chatrooms})
    end
    stream_for "Chatroom@"+chatroom.id.to_s
    MessagesChannel.broadcast_to("Chatroom@"+chatroom.id.to_s, {users: chatroom.users, messages: chatroom.messages})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  
  def receive(content)
    chatroom = Chatroom.find(content['conversation']['id'])
    message = Message.new
    message.content = content['message']
    current_user.messages.push(message)
    current_user.save
    message.save
    chatroom.messages.push(message);
    chatroom.save
    chatroom.reload
    MessagesChannel.broadcast_to("Chatroom@"+content['conversation']['id'].to_s, {users: chatroom.users, messages: chatroom.messages})
  end

  def delete_Message(content)
    chatroom = Chatroom.find(content['conversation']['id'])
    message = Message.find(content['message_id'])
    if(message.user == current_user)
      message.delete
    end
    chatroom.reload
    MessagesChannel.broadcast_to("Chatroom@"+content['conversation']['id'].to_s, {users: chatroom.users, messages: chatroom.messages})
  end
end
