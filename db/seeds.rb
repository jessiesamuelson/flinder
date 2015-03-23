# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all

jessie = User.create({
	name: 'Jessie',
	region: 'Manhattan',
	email: 'jessie@me.com',
	password: 'password'
})


izzie = User.create({
	name: 'Izzie',
	region: 'Brooklyn',
	email: 'izzie@me.com',
	password: 'password'
})


blop = User.create({
	name: 'Blop',
	region: 'Bronx',
	email: 'blop@me.com',
	password: 'password'
})