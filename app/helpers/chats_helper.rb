module ChatsHelper
  def helper_short_message(message:)
    if message.length >= 50
      message[0..47] + "..."
    else
      message
    end
  end

  def helper_unread_message_count(user:, channel:)
    return nil if user.nil?
    return nil if user.unread_message_count(channel: channel) == 0

    "(#{user&.unread_message_count(channel: channel)})".html_safe
  end
end
