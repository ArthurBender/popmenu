separator = "-" * 50

unless Rails.env.development?
  puts "This seed file should only be used in development", separator
  return
end

models = %w[Restaurant Menu MenuItem MenuEntry]

puts separator

models.each do |model|
  if model.constantize.count > 0
    puts "Data already exists, clean the database first", separator
    return
  end
end

puts "Creating menus and menu items...", separator

3.times do |i|
  restaurant = Restaurant.create(name: "Restaurant #{i}")
  2.times do |j|
    menu = restaurant.menus.create(name: "Menu #{j}")

    5.times do |k|
      item = MenuItem.create(name: Faker::Food.dish + " #{j}#{i}#{k}", restaurant: restaurant)

      MenuEntry.create(menu_item_id: item.id, menu: menu, price: rand(1..10))
    end

    # Multiple menu items
    if restaurant.menus.count > 1
      MenuEntry.create(menu_item_id: menu.menu_items.last.id, menu: restaurant.menus.first, price: rand(1..10))
    end
  end
end

puts "Created #{Restaurant.count} restaurants, #{Menu.count} menus and #{MenuItem.count} menu items", separator
