class MessengerController < ApplicationController
  before_action :authenticate_user!

  def index
    @threads = current_user.user_message_threads.includes(:users).order("last_message_at DESC")
    set_threads_statuses(@threads)
  end

  def update_thread
    @user_thread = current_user.user_message_thread_members.find_by(user_message_thread_id: params[:thread_id])
    @user_thread.update(status: params[:status])
    redirect_to messenger_url
  end

  def fetch_thread
    @thread = current_user.user_message_threads.find(params[:thread_id])
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
