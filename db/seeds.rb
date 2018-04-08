# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


if Restaurant.count == 0
  rest_one = Restaurant.new({
    name: "Mie Aceh",
    email: "mieaceh@enak.com",
    phone: "+62221212121"
  })

  rest_one.save

  rest_one.tables.create({
    name: "Table 1",
    minimum_guest: 1,
    maximum_guest: 2
  })  

  rest_one.shifts.create({
    name: "Morning Shift",
    start_at: DateTime.new(2000, 1, 1, 9, 00, 0),
    end_at: DateTime.new(2000, 1, 1, 14, 00, 0)
  })  

  rest_one.shifts.create({
    name: "Afternoon Shift",
    start_at: DateTime.new(2000, 1, 1, 17, 00, 0),
    end_at: DateTime.new(2000, 1, 1, 22, 00, 0)
  })    
end