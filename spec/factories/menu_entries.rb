FactoryBot.define do
  factory :menu_entry do
    price { 1 }
    menu
    menu_item
  end
end
