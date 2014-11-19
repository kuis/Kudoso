# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


admin = User.create({email: 'kaz@kudoso.com', password: 'password', password_confirmation: 'password', admin: true, confirmed_at: Time.now})
parent = User.create({email: 'parent@kudoso.com', password: 'password', password_confirmation: 'password', parent: true, confirmed_at: Time.now})
child = User.create({email: 'child@kudoso.com', password: 'password', password_confirmation: 'password', household_id: parent.household_id, confirmed_at: Time.now})