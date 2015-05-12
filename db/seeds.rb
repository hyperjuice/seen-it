# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

life_question = Post.create({name:"What is the meaning of life?",content:"Write a program that outputs 42",difficulty:"Easy",link:"http://www.google.com"})

non_technical = Tag.create({category:"non-technical"})

