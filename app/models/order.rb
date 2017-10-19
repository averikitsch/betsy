class Order < ApplicationRecord
  has_many :order_products
  has_many :products, :through => :order_products

  # validates :order_products, :presence => true
  validates :name, presence: true
  validates :address, presence: true
  validates :email, presence: true
  validates :cc_num, presence: true #  numericality: { only_integer: true }, length: { is: 16 }
  validates :cc_expiry, presence: true
  validate :card_expiry_cannot_be_in_the_past
  validates :cc_cvv, numericality: { only_integer: true }, length: { is: 3}
  validates :billing_zip, numericality: { only_integer: true }

  private

  def card_expiry_cannot_be_in_the_past
    if !cc_expiry.nil? && Date.strptime(cc_expiry, '%m/%y') < Date.today
      errors.add(:cc_expiry, "can't be in the past")
    end
  end

end
