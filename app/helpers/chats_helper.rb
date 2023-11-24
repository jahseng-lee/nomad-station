module ChatsHelper
  def helper_short_message(message:)
    if message.length >= 50
      message[0..47] + "..."
    else
      message
    end
  end
end
