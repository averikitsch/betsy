class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validate :must_be_in_stock



  def must_be_in_stock
    if self.product.stock == 0
      errors.add(:stock, "product is out of stock")
    end
  end

end
