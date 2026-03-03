separator = "-" * 20

if Menu.count > 0 || MenuItem.count > 0
  puts "Data already exists, clean the database first", separator
  return
end

puts "Creating menus and menu items...", separator

3.times do |i|
  menu = Menu.create(name: "Menu #{i}")

  5.times do
    menu.menu_items.create(
      name: Faker::Food.dish,
      price: rand(1..10)
    )
  end
end

puts "Created #{Menu.count} menus and #{MenuItem.count} menu items", separator
