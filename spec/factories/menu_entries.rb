FactoryBot.define do
  factory :menu_entry do
    price { 1 }
    menu
    menu_item { association :menu_item, restaurant: (menu.try(:restaurant) || create(:restaurant)) }
  end
end
