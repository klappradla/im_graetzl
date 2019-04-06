module RoomsHelper

  def filter_room_types
    [
      ['Alle Raumteiler', ''],
      ['Räume', 'offer'],
      ['Raumsuchende', 'demand'],
      #['Open Calls', 'call'],
      #['Raumteiler Gruppen', 'with_group']
    ]
  end

end
