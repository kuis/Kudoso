# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


admin = User.create({email: 'kaz@kudoso.com', first_name: 'Mike', last_name: 'Kazmier', password: 'password', password_confirmation: 'password', admin: true, confirmed_at: Time.now})
parent = User.create({email: 'parent@kudoso.com', first_name: 'Parent', last_name: 'Test', password: 'password', password_confirmation: 'password', confirmed_at: Time.now})
children = Member.create([{username: 'johnny', first_name: 'Johnny', last_name: 'Test', password: '1234', family_id: parent.family_id},
                          {username: 'suzy', first_name: 'Suzy', last_name: 'Test', password: '4321', family_id: parent.family_id}])

daily = IceCube::Rule.daily
weekdays = IceCube::Rule.weekly.day(:monday, :tuesday, :wednesday, :thursday, :friday)
saturdays = IceCube::Rule.weekly.day(:saturday)
todo_templates = TodoTemplate.create([
    { name: 'Brush teeth', description: 'To prevent cavities bush your teeth for at least 60 seconds.', required: true, schedule: "#{daily.to_yaml}", active: true, kudos: 20 },
    { name: 'Brush hair', description: 'Look your best and get rid of that bed hed!', required: true, schedule: "#{daily.to_yaml}", active: true, kudos: 20 },
    { name: 'Make bed', description: 'Your room is a reflection of you. Your neat! So your bed should be made neatly too.', required: true, schedule: "#{daily.to_yaml}", active: true, kudos: 20 },
    { name: 'Read a book', description: 'Reading is fun, red for at least 30 minute!', required: true, schedule: "#{weekdays.to_yaml}", active: true, kudos: 20 },
    { name: 'Pick up room', description: 'Its easier to pickup every week than to let the mess build!', required: true, schedule: "#{saturdays.to_yaml}", active: true, kudos: 20 },
    { name: 'Finish homework', description: 'Work hard, play hard! Its important to finish your work before playing.', required: true, schedule: "#{weekdays.to_yaml}", active: true, kudos: 20 },
    { name: 'Mow lawn', description: 'Maintaining our home requires everyone to help.', required: true, schedule: "#{saturdays.to_yaml}", active: true, kudos: 20 }
                                     ])

group_one = TodoGroup.create({ name: 'Group One', rec_min_age: 2, rec_max_age: 12, active: true })

group_one.todo_templates << todo_templates[0]
group_one.todo_templates << todo_templates[1]
group_one.todo_templates << todo_templates[2]

parent.family.assign_group(group_one, [children[0].id, children[1].id ])

group_two = TodoGroup.create({ name: 'Group Two', rec_min_age: 6, rec_max_age: 12, active: true })

group_two.todo_templates << todo_templates[3]
group_two.todo_templates << todo_templates[4]

group_three = TodoGroup.create({ name: 'Group Two', rec_min_age: 9, rec_max_age: 12, active: true })

group_three.todo_templates << todo_templates[5]
group_three.todo_templates << todo_templates[5]

# reset todo_schedules to the past
TodoSchedule.find_each do |ts|
  ts.start_date = 45.days.ago.to_date
  ts.save!(validate: false)
end

# create historical my_todos for each child
(45.days.ago.to_date .. 1.days.ago.to_date).each { |d| Family.memorialize_todos(d) }

# randomly mark some todos as complete
children.each do |kid|
  (kid.my_todos.count / 3).floor.times do
    kid.my_todos.where('complete IS NOT TRUE').sample.update_attribute(:complete, true)
  end
end

# generate device types

device_types = DeviceType.create([
                                     { name: 'iPod 4th Gen', description: 'Apple iPod Touch, 4th Generation', os: '', version: '' },
                                     { name: 'iPod 5th Gen', description: 'Apple iPod Touch, 5th Generation', os: '', version: '' },
                                     { name: 'iPhone 4', description: '', os: '', version: '' },
                                     { name: 'iPhone 4s', description: '', os: '', version: '' },
                                     { name: 'iPhone 5c', description: '', os: '', version: '' },
                                     { name: 'iPhone 5s', description: '', os: '', version: '' },
                                     { name: 'iPhone 6', description: '', os: '', version: '' },
                                     { name: 'iPhone 6 Plus', description: '', os: '', version: '' },
                                     { name: 'iPad 1st Gen', description: '', os: '', version: '' },
                                     { name: 'iPad 2nd Gen', description: '', os: '', version: '' },
                                     { name: 'iPad Retina', description: '', os: '', version: '' },
                                     { name: 'iPad Air', description: '', os: '', version: '' },
                                     { name: 'iPad Air 2nd Gen', description: '', os: '', version: '' },
                                     { name: 'Playstation 2', description: '', os: '', version: '' },
                                     { name: 'Playstation 3', description: '', os: '', version: '' },
                                     { name: 'Playstation 4', description: '', os: '', version: '' },
                                     { name: 'xBox 360', description: '', os: '', version: '' },
                                     { name: 'xBox One', description: '', os: '', version: '' },
                                     { name: 'Nintendo Wii', description: '', os: '', version: '' },
                                     { name: 'Nintendo 3DS', description: '', os: '', version: '' },
                                     { name: 'Kudoso Smart Plug', description: '', os: '', version: '' },
                                     { name: 'BluRay Player', description: '', os: '', version: '' },
                                     { name: 'HDTV', description: '', os: '', version: '' }

                                 ])