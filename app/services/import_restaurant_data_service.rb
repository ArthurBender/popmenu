class ImportRestaurantDataService
  SCHEMA_PATH = Rails.root.join("schemas/import.json").freeze

  def self.call(file)
    new(file).call
  end

  def initialize(file)
    @file = file
    @errors = 0
    @logs = []
  end

  def call
    log("Started process.")

    data = JSON.parse(@file.read)
    log("File parsed.")

    validate_structure!(data)
    log("File schema validated.")

    initial_data = count_data

    data.fetch("restaurants").each do |restaurant_data|
      import_restaurant(restaurant_data)
    end

    final_data = compare_data(count_data, initial_data)

    {
      "logs" => @logs,
      "totals" => final_data.merge("errors" => @errors)
    }
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
    restaurant = Restaurant.find_or_create_by!(name: restaurant_data["name"]) do
      log("Created restaurant #{restaurant_data["name"]}.")
    end

    restaurant_data["menus"].each do |menu_data|
      menu = restaurant.menus.find_or_create_by!(name: menu_data["name"]) do
        log("Created menu #{menu_data["name"]}.")
      end

      (menu_data["menu_items"] || menu_data["dishes"]).each do |item_data|
        menu_item = MenuItem.find_or_create_by!(name: item_data["name"], restaurant: restaurant) do
          log("Created item #{item_data["name"]}.")
        end

        begin
          menu.menu_entries.find_or_create_by!(menu_item: menu_item) do |menu_entry|
            menu_entry.price = item_data["price"]
            log("Added entry for #{item_data["name"]} with price #{item_data["price"]} to menu #{menu_data["name"]}.")
          end

          log(
            "Imported menu item.",
            item_log: {
              status: "success",
              restaurant: restaurant_data["name"],
              menu: menu_data["name"],
              item: item_data["name"],
              price: item_data["price"]
            }
          )
        rescue ActiveRecord::RecordInvalid => e
          @errors += 1
          log(
            "Error adding entry for #{item_data["name"]} with price #{item_data["price"]} to menu #{menu_data["name"]}: #{e.message}.",
            error: true,
            item_log: {
              status: "failed",
              restaurant: restaurant_data["name"],
              menu: menu_data["name"],
              item: item_data["name"],
              price: item_data["price"]
            }
          )
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

  def log(message, error: false, item_log: nil)
    formatted_message = "[Conversion Tool] #{message}"
    if error
      Rails.logger.error(formatted_message)
    else
      Rails.logger.info(formatted_message)
    end

    return if item_log.nil?

    @logs << {
      "status" => item_log.fetch(:status),
      "restaurant" => item_log.fetch(:restaurant),
      "menu" => item_log.fetch(:menu),
      "item" => item_log.fetch(:item),
      "price" => item_log.fetch(:price),
      "message" => message
    }
  end
end
