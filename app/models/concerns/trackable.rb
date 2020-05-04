module Trackable
  extend ActiveSupport::Concern

  included do
    has_many :activities, as: :trackable, dependent: :destroy
  end

  def create_activity(activity_name, options = {})
    options[:key] = "#{self.class.name.demodulize.underscore}.#{activity_name}"
    self.activities.create(options)
  end

end
