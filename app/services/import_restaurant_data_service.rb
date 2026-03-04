class ImportRestaurantDataService
  SCHEMA_PATH = Rails.root.join("schemas/import.json").freeze

  def self.call(file)
    new(file).call
  end

  def initialize(file)
    @file = file
    @errors = 0
  end

  def call
    data = JSON.parse(@file.read)

    validate_structure!(data)

    initial_data = count_data

    data.fetch("restaurants").each do |restaurant_data|
      import_restaurant(restaurant_data)
    end

    final_data = compare_data(count_data, initial_data)

    final_data.merge("errors" => @errors)
  end

  private

  def validate_structure!(data)
    JSON::Validator.validate!(SCHEMA_PATH.to_s, data)
  end

  def count_data
    {
      "restaurants" => Restaurant.count,
      "menus" => Menu.count,
      "menu_items" => MenuItem.count,
      "menu_entries" => MenuEntry.count
    }
  end

  def import_restaurant(restaurant_data)
    restaurant = Restaurant.find_or_create_by!(name: restaurant_data["name"])

    restaurant_data["menus"].each do |menu_data|
      menu = restaurant.menus.find_or_create_by!(name: menu_data["name"])

      (menu_data["menu_items"] || menu_data["dishes"]).each do |item_data|
        menu_item = MenuItem.find_or_create_by!(name: item_data["name"])

        begin
          menu.menu_entries.find_or_create_by!(menu_item: menu_item) do |menu_entry|
            menu_entry.price = item_data["price"]
          end
        rescue ActiveRecord::RecordInvalid
          @errors += 1
        end
      end
    end
  end

  def compare_data(initial_data, final_data)
    result = {}

    initial_data.each do |key, value|
      result[key] = (final_data[key] - value).abs
    end

    result
  end
end
