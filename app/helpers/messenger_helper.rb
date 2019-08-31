module MessengerHelper

  def thread_other_user(thread)
    (thread.users - [current_user]).first || current_user
  end

  def message_thread_class(thread)
    if thread.status == "deleted"
      "deleted hidden"
    elsif thread.status ==  "archived"
      "archived hidden"
    elsif thread.tool_rental_id
      "active tool_rental"
    else
      'active'
    end
  end
end
