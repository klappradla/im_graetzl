module MessengerHelper

  def thread_other_user(thread)
    (thread.users - [current_user]).first || current_user
  end

  def message_thread_class(thread)
    #if thread.status == "deleted"
    #  "deleted hidden"
    #elsif thread.status ==  "archived"
    #  "archived hidden"
    if thread.tool_rental_id
      "active tool_rental"
    elsif thread.room_rental_id
      "active room_rental"
    elsif thread.last_message.nil? && params[:thread_id].to_i != thread.id
      "active empty"
    else
      'active'
    end
  end
end
