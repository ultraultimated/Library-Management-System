# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Admin.create!([{
	name: "administrator",
	email: "dshah11@ncsu.edu",
	password_digest: "$2b$10$mm9uguS51L76GbEP4mn2wuA4FVoDil2BE7QFF3j4bhThIhwBR8IaC"
}])
