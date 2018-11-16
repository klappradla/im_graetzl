module LocationsHelper
  def location_meta(location)
    address = location.address
    desc = ''
    if address
      desc << "#{address.street_name} #{address.street_number.split(%r{/}).first}, #{address.zip} #{address.city} | "
    end
    desc << location.description
    desc[0..154]
  end

  def link_to_add_address_fields(name, f)
    f.object.build_address
    fields = render('address_fields', f: f)
    link_to(name, '#', class: 'add_address_fields btn-secondary',
            data: { fields: fields.gsub('\n','') })
  end

  def link_to_add_graetzl_fields(name, object)
    fields = render('shared/graetzl_select', object: object)
    link_to(name, '#', class: 'add_graetzl_fields link-subtle',
            data: { fields: fields.gsub('\n','') })
  end
end
