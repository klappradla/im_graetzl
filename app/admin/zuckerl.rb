ActiveAdmin.register Zuckerl do
  menu parent: :locations
  after_save do |zuckerl|
    event = params[:zuckerl][:active_admin_requested_event]
    zuckerl.send("#{event}!") unless event.blank?
  end

  filter :location
  filter :title
  filter :description
  filter :flyer
  filter :all_districts
  filter :aasm_state, as: :select, collection: Zuckerl.aasm.states_for_select
  filter :paid_at
  filter :created_at

  scope "#{I18n.localize Time.now.end_of_month+1.day, format: '%B'} Zuckerl", :next_month_live, default: true
  scope "Aktueller Monat", :this_month_live

  scope "Alle", :all
  scope "Bezahlt", :marked_as_paid
  scope :pending
  scope :cancelled
  scope :expired

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

  batch_action :mark_as_paid do |ids|
    batch_action_collection.find(ids).each do |zuckerl|
      zuckerl.mark_as_paid! if zuckerl.may_mark_as_paid?
    end
    redirect_to collection_path, alert: 'Die ausgewählten Zuckerl wurden als bezahlt markiert.'
  end
  batch_action :put_live do |ids|
    batch_action_collection.find(ids).each do |zuckerl|
      zuckerl.put_live! if zuckerl.may_put_live?
    end
    redirect_to collection_path, alert: 'Die ausgewählten Zuckerl wurden live gestellt.'
  end
  batch_action :expire do |ids|
    batch_action_collection.find(ids).each do |zuckerl|
      zuckerl.expire! if zuckerl.may_expire?
    end
    redirect_to collection_path, alert: 'Die ausgewählten Zuckerl wurden als abgelaufen markiert.'
  end
  batch_action :cancel do |ids|
    batch_action_collection.find(ids).each do |zuckerl|
      zuckerl.cancel! if zuckerl.may_cancel?
    end
    redirect_to collection_path, alert: 'Die ausgewählten Zuckerl wurden als gelöscht markiert.'
  end

  permit_params :location_id,
                :title,
                :description,
                :flyer,
                :all_districts,
                :aasm_state,
                :active_admin_requested_event,
                :paid_at,
                :image, :remove_image,
                :initiative_id,
                :link
  # Within app/admin/resource_name.rb
  # Controller pagination overrides
  controller do
    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end
  end
end
