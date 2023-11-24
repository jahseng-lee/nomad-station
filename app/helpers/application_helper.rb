module ApplicationHelper
  def helper_user_initials(user:)
    split_display_name = user.display_name.upcase.split(" ")
    if split_display_name.length >= 2
      "#{split_display_name[0][0]}#{split_display_name[1][0]}"
    elsif split_display_name[0].length >= 2
      "#{split_display_name[0][0]}#{split_display_name[0][1]}"
    else
      "#{split_display_name[0]}"
    end
  end
end
