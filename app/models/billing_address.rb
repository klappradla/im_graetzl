class BillingAddress < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :user, optional: true

  #validates :first_name, presence: true
  #validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}" if first_name.present? || last_name.present?
  end

  def full_city
    "#{zip} #{city}"
  end

  def full_name=(value)
    split = value.split(' ')
    self.last_name = split.pop || ''
    self.first_name = split.join(' ')
  end

  def full_city=(value)
    split = value.split(' ')
    self.zip = split.shift
    self.city = split.join(' ')
  end
end
