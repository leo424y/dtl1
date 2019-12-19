# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Node.create(name: 'n1', archive: {na: "n1a"})
Node.last.posts.create(title: 'n1p1', archive: {pa: "n1p1a"})
Node.last.posts.create(title: 'n1p2', archive: {pa: "n1p2a"})