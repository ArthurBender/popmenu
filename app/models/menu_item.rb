class MenuItem < ApplicationRecord
  belongs_to :restaurant

  has_many :menu_entries, dependent: :destroy
  has_many :menus, through: :menu_entries

  validates :name, presence: true
  validates :name, uniqueness: { scope: :restaurant_id }
end
