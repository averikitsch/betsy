class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validate :stock_quantity
  validate :must_be_in_stock


  def must_be_in_stock
    if self.product.stock == 0
      errors.add(:stock, "product is out of stock")
    end
  end

  def stock_quantity
    if self.quantity > self.product.stock
      errors.add(:stock, "product stock is #{self.product.stock}")
    end
  end
end
