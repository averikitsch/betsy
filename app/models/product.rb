class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :user
  has_many :order_products
  has_many :reviews

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :price, presence: true
  validates :price, numericality: {greater_than: 0}
  validates :stock, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
