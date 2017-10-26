class Order < ApplicationRecord
  STATUS = %w(pending paid complete cancelled)
  has_many :order_products, dependent: :destroy
  has_many :products, :through => :order_products

  # validates :order_products, :presence => true, :if => :confirm_payment?
  validates :name, presence: true, :if => :confirm_payment?
  validates :address, presence: true, :if => :confirm_payment?
  validates :email, presence: true, :if => :confirm_payment?
  validates :cc_num, presence: true,  numericality: { only_integer: true }, length: { is: 16 }, :if => :confirm_payment?
  validates :cc_expiry, presence: true, :if => :confirm_payment?
  validate :card_expiry_checks, :if => :confirm_payment?
  validates :cc_cvv, numericality: { only_integer: true }, length: { is: 3}, :if => :confirm_payment?
  validates :billing_zip, numericality: { only_integer: true }, :if => :confirm_payment?
  validates :status, presence: true, inclusion: { in: STATUS }

  scope :status, ->(status) { where('status = ?', status) } 

  private

  def card_expiry_checks
    if !(cc_expiry.nil? || cc_expiry.empty?)
      begin
        if Date.strptime(cc_expiry, '%m/%y') < Date.today
          errors.add(:cc_expiry, "can't be expired")
        end
      rescue ArgumentError
        errors.add(:cc_expiry, "in wrong format")
      end
    end
  end

  def confirm_payment?
    self.status == "paid"
  end
end
