class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_admin_user!, only: [:create, :new] # New: Create Groups only for Admin Users


  def index
    head :ok and return if browser.bot? && !request.format.js?
    @groups = collection_scope.include_for_box
    @groups = filter_collection(@groups)
    @groups = @groups.by_currentness.page(params[:page]).per(15)
  end

  def show
    @group = Group.find(params[:id])
    @group.group_users.to_a # Preload users
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
      GroupMailer.group_online(@group, current_user).deliver_later
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
    redirect_to @group and return if @group.group_join_requests.exists?(user: current_user)

    if params[:join_answers].present?
      questions_and_answers = @group.group_join_questions.map(&:question).zip(params[:join_answers]).flatten
      join_request = @group.group_join_requests.create(
        user: current_user,
        join_answers: questions_and_answers,
      )
    else
      join_request = @group.group_join_requests.create(
        user: current_user,
        request_message: params[:request_message],
      )
    end
    join_request.group.admins.each do |group_admin|
      GroupMailer.new_join_request(join_request, group_admin).deliver_later
    end
    flash[:notice] = 'Deine Beitrittsanfrage wurde abgeschickt!'
    redirect_to @group
  end

  def accept_request
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)

    @join_request = @group.group_join_requests.find(params[:join_request_id])

    if !@group.users.include?(@join_request.user)
      group_user = @group.group_users.create(user: @join_request.user)

      if @group.save
        group_user.create_activity(:create, owner: current_user)
        GroupMailer.join_request_accepted(@group, @join_request.user).deliver_later
      end

    end

    @join_request.accepted!

    redirect_to group_url(@group, anchor: "tab-members")
  end

  def reject_request
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)

    @join_request = @group.group_join_requests.find(params[:join_request_id])
    @join_request.rejected!

    redirect_to group_url(@group, anchor: "tab-members")
  end

  def remove_user
    @group = Group.find(params[:id])
    @group_user = @group.group_users.find_by(user_id: params[:user_id])
    redirect_to @group and return unless (@group.admins.include?(current_user) || current_user.id == @group_user.user_id)

    @group_user.destroy
    @group.group_join_requests.where(user_id: @group_user.user_id).delete_all

    redirect_to group_url(@group, anchor: "tab-members")
  end

  def compose_mail
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)
  end

  def send_mail
    @group = Group.find(params[:id])
    redirect_to @group and return unless @group.admins.include?(current_user)

    User.where(id: params[:user_ids]).find_each do |user|
      GroupMailer.message_to_user(
        @group, current_user, user, params[:subject], params[:body], params[:from_email]
      ).deliver_later
    end
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
    Group.all
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
        :welcome_message,
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
