# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


admin = User.create({email: 'kaz@kudoso.com', first_name: 'Mike', last_name: 'Kazmier', password: 'password', password_confirmation: 'password', admin: true, confirmed_at: Time.now})
parent = User.create({email: 'parent@kudoso.com', first_name: 'Parent', last_name: 'Test', password: 'password', password_confirmation: 'password', confirmed_at: Time.now})
child = Member.create({username: 'johnny', first_name: 'Johnny', last_name: 'Test', password: 'password', family_id: parent.family_id})