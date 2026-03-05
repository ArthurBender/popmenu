FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Item #{n}" }
    restaurant
  end
end
