class Graetzl < ApplicationRecord
  extend FriendlyId

  friendly_id :name

  has_one :curator, dependent: :destroy
  has_many :users
  has_many :meetings, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :room_offers
  has_many :room_demand_graetzls
  has_many :room_demands, through: :room_demand_graetzls
  has_many :group_graetzls
  has_many :groups, through: :group_graetzls
  has_many :operating_ranges
  has_many :initiatives, through: :operating_ranges, source: :operator, source_type: 'Initiative'
  has_many :admin_posts, through: :operating_ranges, source: :operator, source_type: 'Post'

  has_many :district_graetzls
  has_many :districts, through: :district_graetzls

  def district
    districts.first
  end

  def zuckerls
    related_graetzl_ids = districts.map(&:graetzl_ids).flatten
    Zuckerl.live.includes(location: [:address, :category]).
      joins(:graetzl).where(graetzls: { id: related_graetzl_ids})
  end

  def build_meeting
    meetings.build(address: Address.new)
  end

end
