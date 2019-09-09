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

end
