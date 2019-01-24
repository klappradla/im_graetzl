class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    head :ok and return if browser.bot? && !request.format.js?
    @groups = collection_scope.includes(:group_categories, :users, :room_call, :room_offer)
    @groups = filter_collection(@groups)
    @groups = @groups.by_currentness.page(params[:page]).per(15)
  end

  def show
    @group = Group.find(params[:id])
    if @group.readable_by?(current_user)
      @next_meeting = @group.meetings.where("DATE(starts_at_date) >= ?", Date.today).order(:starts_at_date, :starts_at_time).first
      @discussions = @group.discussions.includes(discussion_posts: [:user, :images]).order("sticky DESC, last_post_at DESC")
      @meetings = @group.meetings.order("starts_at_date DESC")
    end
  end

  def new
    @group = Group.new(
      location_id: params[:location_id],
      room_offer_id: params[:room_offer_id],
      room_demand_id: params[:room_demand_id],
      room_call_id: params[:room_call_id],
      graetzl_ids: Array(params[:graetzl_id]),
    )
    DiscussionDefaultCategory.all.each do |category|
      @group.discussion_categories.build(title: category.title)
    end
  end

  def create
    @group = Group.new(group_params)
    @group.group_users.build(user_id: current_user.id, role: :admin)

    if @group.save
      @group.create_activity(:create, owner: current_user)
      redirect_to @group
    else
      render 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)
  end

  def update
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)

    if @group.update(group_params)
      redirect_to @group
    else
      render 'edit'
    end
  end

  def request_join
    @group = Group.find(params[:id])
    if !@group.group_join_requests.exists?(user: current_user)
      join_request = @group.group_join_requests.create(
        user: current_user,
        join_answers: @group.group_join_questions.map(&:question).zip(params[:join_answers]).flatten,
        request_message: params[:request_message],
      )
      GroupMailer.new.new_join_request(join_request)
      flash[:notice] = 'Deine Beitrittsanfrage wurde abgeschickt!'
    end

    redirect_to @group
  end

  def accept_request
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)

    @join_request = @group.group_join_requests.find(params[:join_request_id])

    group_user = @group.group_users.create(user: @join_request.user)
    group_user.create_activity(:create, owner: current_user)

    @join_request.destroy

    GroupMailer.new.join_request_accepted(@group, @join_request.user)
    redirect_to group_url(@group, anchor: "tab-members")
  end

  def reject_request
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)

    @join_request = @group.group_join_requests.find(params[:join_request_id])
    @join_request.update(rejected: true)
    redirect_to group_url(@group, anchor: "tab-members")
  end

  def remove_user
    @group = Group.find(params[:id])
    @group_user = @group.group_users.find_by(user_id: params[:user_id])
    redirect_to @group and return unless (@group.admins.include?(current_user) || current_user.id == @group_user.user_id)

    @group_user.destroy
    redirect_to group_url(@group, anchor: "tab-members")
  end

  def compose_mail
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)
  end

  def send_mail
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)

    GroupMailer.new.message_to_users(
      @group, current_user, User.where(id: params[:user_ids]), params[:subject], params[:body], params[:from_email]
    )
    redirect_to @group, notice: 'Deine E-Mail wurde versendet ..'
  end

  def destroy
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)

    @group.destroy
    redirect_to root_path, notice: 'Gruppe gelöscht'
  end

  private

  def collection_scope
    #Group.non_private
    #Group.non_hidden
    Group
  end

  def filter_collection(groups)
    district_ids = params[:district_ids]&.select(&:present?)
    if district_ids.present?
      graetzl_ids = Graetzl.joins(:districts).where(districts: {id: district_ids}).distinct.pluck(:id)
      groups = groups.joins(:group_graetzls).where(group_graetzls: {graetzl_id: graetzl_ids}).distinct
    end

    if params[:group_category_id].present?
      groups = groups.joins(:group_categories).where(group_categories: {id: params[:group_category_id]}).distinct
    elsif params[:query].present?
      groups = groups.joins(:group_categories).where("groups.title ILIKE :q OR group_categories.title ILIKE :q", q: "%#{params[:query]}%").distinct
    else
      groups = groups.non_hidden
    end

    groups
  end

  def group_params
    params
      .require(:group)
      .permit(
        :title,
        :description,
        :private,
        :room_offer_id,
        :room_demand_id,
        :room_call_id,
        :location_id,
        :cover_photo, :remove_cover_photo,
        graetzl_ids: [],
        group_category_ids: [],
        group_join_questions_attributes: [:id, :question, :_destroy],
        discussion_categories_attributes: [
          :id, :title, :_destroy
        ],
    )
  end
end
