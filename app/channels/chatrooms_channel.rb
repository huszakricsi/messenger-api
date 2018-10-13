class ChatroomsChannel < ApplicationCable::Channel
  def subscribed
    stream_for "ChatroomsChannel"
    ChatroomsChannel.broadcast_to("ChatroomsChannel", {YourRooms: current_user.chatrooms})
  end

  def create_Room(data)
    if(!data['identifier'].include?(':'))
      chatroom = Chatroom.new
      chatroom.identifier=data['identifier']
      users_to_chatroom = []
      data['participants'].each do |usr|
        chatroom.users.push(User.find(usr['id']))
      end
      chatroom.users.push(current_user)
      chatroom.save!
      current_user.reload #needed because changes wont be seen
    end
    ChatroomsChannel.broadcast_to("ChatroomsChannel", {YourRooms: current_user.chatrooms})
  end

  def delete_Room(data)
    chatroom = Chatroom.find(data['chatroom_id'])
    if(current_user.chatrooms.include?(chatroom))
      chatroom.messages.each do |current_message|
        current_message.delete
      end
      chatroom.delete
    end
    current_user.reload #needed because changes wont be seen
    ChatroomsChannel.broadcast_to("ChatroomsChannel", {YourRooms: current_user.chatrooms})
  end
end