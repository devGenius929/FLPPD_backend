# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# PropertyType.create(ptype: 'Rental')
# PropertyType.create(ptype: 'Flip')

ActiveRecord::Base.connection.execute('TRUNCATE propertylistings RESTART IDENTITY')
Propertylisting.create(pl_name: 'Basic')
Propertylisting.create(pl_name: 'Platinum')
