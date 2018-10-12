class ChatroomsChannel < ApplicationCable::Channel
  def subscribed
    stream_for "ChatroomsChannel"
    ChatroomsChannel.broadcast_to("ChatroomsChannel", {YourRooms: current_user.chatrooms})
  end

  def create_Room(data)
    chatroom = Chatroom.new
    chatroom.identifier=data['identifier']
    users_to_chatroom = []
    data['participants'].each do |usr|
      chatroom.users.push(User.find(usr['id']))
    end
    chatroom.users.push(current_user)
    chatroom.save!
    current_user.reload #needed because changes wont be seen
    ChatroomsChannel.broadcast_to("ChatroomsChannel", {YourRooms: current_user.chatrooms})
  end
end