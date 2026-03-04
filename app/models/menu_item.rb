class MenuItem < ApplicationRecord
  has_many :menu_entries, dependent: :destroy
  has_many :menus, through: :menu_entries

  validates :name, presence: true
  validates :name, uniqueness: true
end
