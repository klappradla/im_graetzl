class MessengerController < ApplicationController
  before_action :authenticate_user!

  def index
    @threads = current_user.user_message_threads.includes(:users).order("last_message_at DESC")
    set_threads_statuses(@threads)
  end

  def update_thread
    @thread = current_user.user_message_thread_members.find_by(user_message_thread_id: params[:thread_id])
    @thread.update(status: params[:status])
    redirect_to messenger_url
  end

  def fetch_thread
    @thread = current_user.user_message_threads.find(params[:thread_id])
  end

  def fetch_new_messages
    @thread = current_user.user_message_threads.find(params[:thread_id])
    @user_messages = @thread.user_messages.where("id > ?", params[:last_message_id]).includes(:user)
  end

  def post_message
    @thread = current_user.user_message_threads.find(params[:thread_id])
    message = params[:message].to_s.strip
    if message.present?
      @user_message = @thread.user_messages.create(user: current_user, message: message)
    else
      head :ok
    end
  end

  private

  def set_threads_statuses(threads)
    statuses = current_user.user_message_thread_members.pluck(:user_message_thread_id, :status).to_h
    threads.each { |t| t.status = statuses[t.id] }
  end
end
