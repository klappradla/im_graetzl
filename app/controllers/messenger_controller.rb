class MessengerController < ApplicationController
  before_action :authenticate_user!

  def index
    #@threads = current_user.user_message_threads.includes(:users).order("last_message_at DESC")
    #set_threads_statuses(@threads)
  end

  def start_thread
    if params[:room_rental_id].present?
      room_rental = RoomRental.find(params[:room_rental_id])
      thread = UserMessageThread.create_for_room_rental(room_rental)
    elsif params[:tool_rental_id].present?
      tool_rental = ToolRental.find(params[:tool_rental_id])
      thread = UserMessageThread.create_for_tool_rental(tool_rental)
    elsif params[:user_id].present? && params[:user_id] != current_user.id
      user = User.find(params[:user_id])
      thread = UserMessageThread.create_general(current_user, user)
    else
      redirect_to root_path, notice: 'No thread found.' and return
    end

    redirect_to messenger_url(thread_id: thread.id)
  end

  def update_thread
    @user_thread = current_user.user_message_thread_members.find_by(user_message_thread_id: params[:thread_id])
    @user_thread.update(status: params[:status])
    redirect_to messenger_url
  end

  def fetch_thread
    @thread = current_user.user_message_threads.find(params[:thread_id])
  end

  def fetch_thread_list

    deleted_ids = current_user.user_message_thread_members.where(status: "deleted").pluck(:user_message_thread_id)
    @threads = current_user.user_message_threads.where.not(id: deleted_ids).includes(:users).page(params[:page]).per(params[:per_page]).order("last_message_at DESC")
    @threads = filter_collection(@threads)

    if params[:thread_id].present?
      # Load Sidebar Thread from Url-Param and Attach to Thread-List
      @threads = (current_user.user_message_threads.where(id: params[:thread_id]) + @threads)
      @threads = @threads.uniq{|t| t.id }
    end

  end

  def fetch_new_messages
    @thread = current_user.user_message_threads.find(params[:thread_id])
    @user_messages = @thread.user_messages.includes(:user)
    @user_messages = @user_messages.where("id > ?", params[:last_message_id]).order(:id) if params[:last_message_id].present?
    if @user_messages.present?
      update_last_seen(@thread, @user_messages.last)
    end
  end

  def post_message
    @thread = current_user.user_message_threads.find(params[:thread_id])
    message = params[:message].to_s.strip
    if message.present?
      @user_message = @thread.user_messages.create(user: current_user, message: message)
      update_last_seen(@thread, @user_message)
    else
      head :ok
    end
  end

  private

  def filter_collection(threads)

    if params[:filter].present? && UserMessageThread.thread_types[params[:filter]]
      archived_ids = current_user.user_message_thread_members.where(status: "archived").pluck(:user_message_thread_id)
      threads = threads.where.not(id: archived_ids).where(thread_type: params[:filter])
    elsif params[:filter].present? && UserMessageThreadMember.statuses[params[:filter]]
      filtered_ids = current_user.user_message_thread_members.where(status: params[:filter]).pluck(:user_message_thread_id)
      threads = threads.where(id: filtered_ids)
    else
      active_ids = current_user.user_message_thread_members.where(status: "active").pluck(:user_message_thread_id)
      threads = threads.where(id: active_ids)
    end

    threads
  end

  def set_threads_statuses(threads)
    statuses = current_user.user_message_thread_members.pluck(:user_message_thread_id, :status).to_h
    threads.each { |t| t.status = statuses[t.id] }
  end

  def update_last_seen(thread, message)
    thread.user_message_thread_members.where(
      user_id: current_user.id
    ).where(
      "last_message_seen_id < ?", message.id
    ).update_all(
      last_message_seen_id: message.id
    )
  end

end
