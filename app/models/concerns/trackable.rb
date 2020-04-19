module Trackable
  extend ActiveSupport::Concern

  included do
    has_many :activities, as: :trackable, dependent: :destroy
  end

  def create_activity(activity_name, options = {})
    if (options[:parameters] && options[:parameters][:cross_platform])
      options[:key] = "cross_platform.#{self.class.name.demodulize.underscore}.#{activity_name}"
    else
      options[:key] = "#{self.class.name.demodulize.underscore}.#{activity_name}"
    end
    self.activities.create(options)
  end
end
