class GroupMailerPreview < ActionMailer::Preview

  def group_online
    GroupMailer.group_online(Group.first, User.first)
  end

  def new_join_request
    GroupMailer.new_join_request(GroupJoinRequest.last, User.first)
  end

  def join_request_accepted
    GroupMailer.join_request_accepted(Group.first, User.first)
  end

  def message_to_user
    GroupMailer.message_to_user(Group.first, User.first, User.last, "Hello", "Hello world", "test")
  end

end
