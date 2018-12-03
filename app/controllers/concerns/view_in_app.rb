# Shared method for ActiveAdmin resources
module ViewInApp
  extend ActiveSupport::Concern

  def self.included(base)
    # Shared action_item (use 'send' due to 'action_item' is a private method)
    base.send(:action_item, :view_in_app, only: :show) do
      if [RoomOffer, RoomDemand, RoomCall, Group].any? { |c| resource.is_a?(c) }
        link_to 'In App ansehen', resource
      elsif resource.respond_to?(:graetzl)
        link_to 'In App ansehen', [resource.graetzl, resource]
      elsif resource.is_a?(Graetzl)
        link_to 'In App ansehen', resource
      end
    end
  end
end
