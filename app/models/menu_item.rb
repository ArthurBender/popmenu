class MenuItem < ApplicationRecord
  has_many :menu_entries, dependent: :destroy
  has_many :menus, through: :menu_entries

  validates :name, :price, presence: true
  validates :name, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
end
