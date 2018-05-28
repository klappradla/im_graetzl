module RoomsHelper

  def filter_room_types
    [
      ['Alle Raumteiler', ''],
      ['Raumangebote', 'offer'],
      ['Raumsuchende', 'demand'],
      ['Open Calls', 'call'],
    ]
  end

  def compact_room_demand_graetzl_list(room_demand)
    districts = room_demand.districts.includes(:graetzls)
    graetzls = room_demand.graetzls.includes(:districts)
    graetzl_ids = room_demand.graetzls.map{|g| [g.id, g]}.to_h

    whole_districts = []
    districts.each do |district|
      if Set.new(district.graetzl_ids).subset?(Set.new(graetzl_ids.keys))
        whole_districts << district
      end
    end

    whole_districts.each do |district|
      district.graetzl_ids.each { |gid| graetzl_ids.delete(gid) }
    end

    result = []
    result += whole_districts.map(&:zip_name)
    result += graetzl_ids.map{|_, g| "#{g.district.zip} - #{g.name}"}
    result
  end

end
