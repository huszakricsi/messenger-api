class MessagesChannel < ApplicationCable::Channel
  def subscribed(chat_room_id)
    stream_for chat_room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  
  def receive(data)
  end
end
