# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

life_question = Post.create({name:"What is the meaning of life?",content:"Write a program that outputs 42",difficulty:"Easy",link:"http://www.google.com"})

non_technical = Tag.create({category:"non-technical"})

chris = User.create({first_name:"Chris",last_name:"Reeve",email:"pln2bz@vireo.net", encrypted_password: "$2a$10$1WosUHld0s/R20cN9dVwc.8xZVTHh68Dikwvfvt9PR/71b1/T3Fqy"})

