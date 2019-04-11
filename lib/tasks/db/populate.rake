namespace :db do
  desc 'Erase and fill db with sample data'
  task populate: :environment do

    # remove old data
    puts 'remove old data'
    [User, Meeting, Location, Post, Category, Activity].each(&:destroy_all)

    # check for seed data
    puts 'check for graetzl and districts'
    if Graetzl.none? || District.none?
      puts 'invoke db:seed'
      Rake::Task['db:seed'].invoke
    end

    # add users
    puts 'add users'
    users = ['malano', 'mirjam', 'jack', 'peter', 'jeanine', 'max', 'tawan']
    users.each do |user|
      new_user = User.new(
        username: user,
        first_name: user,
        last_name: user,
        email: user + '@example.com',
        password: 'secret',
        role: :admin,
        graetzl: Graetzl.find_by_name('Stuwerviertel'),
        confirmed_at: Time.now,
        slug: user)
      File.open(Rails.root+"lib/assets/avatars/#{user}.gif", 'rb') do |file|
        new_user.avatar = file
      end
      new_user.save(validate: false)
    end

    user_1 = User.create(
      username: 'user_1',
      first_name: 'user_1',
      last_name: 'user_1',
      email: 'user_1@example.com',
      password: 'secret',
      role: :business,
      graetzl: Graetzl.find_by_name('Stuwerviertel'),
      confirmed_at: Time.now,
      slug: 'user_1')
    File.open(Rails.root+'lib/assets/avatars/user_1.jpg', 'rb') do |file|
      user_1.avatar = file
    end
    user_1.save(validate: false)

    # add categories
    puts 'add categories'
    location_categories = [
      'Kreativwirtschaft / Handwerk',
      'Wohlbefinden & Gesundheit',
      'Unternehmen & Start-ups',
      'Geschäft / Ladenlokal im Grätzl',
      'Gastronomie',
      'Lokaler Dienstleister',
      'Öffentlicher Raum / Sozialer Treffpunkt',
      'Leerstand',
      'Sonstige Tätigkeit']
    location_categories.each do |c|
      Category.create(name: c, context: Category.contexts[:business])
    end

    # add locations
    puts 'add locations'
    users = User.all
    category = Category.business.first
    2.times do
      users.each do |u|
        u.locations.create(
          graetzl: u.graetzl,
          name: Faker::Company.name,
          slogan: Faker::Company.catch_phrase,
          description: Faker::Lorem.paragraph(10),
          state: 'approved',
          category: category,
          contact_attributes: {
            website: Faker::Internet.url,
            email: Faker::Internet.email,
            phone: Faker::PhoneNumber.cell_phone
          })
      end
    end

    # add meetings
    puts 'add meetings'
    users = User.all
    4.times do
      users.each do |u|
        meeting = u.graetzl.meetings.create(
          name: Faker::Lorem.sentence(3),
          user: u,
          description: Faker::Lorem.paragraph(6),
          starts_at_date: Faker::Date.forward(20),
          address_attributes: {
            street_name: Faker::Address.street_name,
            street_number: Faker::Address.building_number,
            zip: Faker::Address.zip,
            description: Faker::Lorem.sentence(2),
            coordinates: 'POINT (16.353172456228375 48.194235057984216)'
          })
        meeting.create_activity :create, owner: u
      end
    end

    # add posts
    # puts 'add posts'
    # users = User.all
    # posts = []
    # 10.times do
    #   users.each do |u|
    #     posts << u.posts.build(content: Faker::Lorem.paragraph(3), graetzl: u.graetzl)
    #   end
    # end
    # posts.shuffle.each do |p|
    #   p.save
    #   p.create_activity :create, owner: p.author
    # end

    # save slugs
    User.find_each(&:save)
  end
end
