class User < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.from_auth_hash(provider, auth_hash)
    user = new
    user.provider = provider
    user.uid = auth_hash['uid']
    user.username = auth_hash['info']['nickname']
    user.email = auth_hash['info']['email']

    return user
  end

<<<<<<< HEAD
  def orders(status)
    Order.where(status: status)
    .joins(:products).where('products.user_id = ?', id).distinct
=======
  def orders
    Order.where(status:["paid","complete"]).joins(:products).where('products.user_id = ?', id).distinct
>>>>>>> 4acce3c822b0d3348c1bd0a5e980dc8b5fa2508f
  end

  def order_products
    product_ids = products.collect { |product| product.id }
<<<<<<< HEAD
    order_products = OrderProduct.where(:product_id => product_ids).joins(:order).where("orders.status = ? OR orders.status = ?", "paid","completed")
=======
    order_products = OrderProduct.where(:product_id => product_ids).joins(:order).where("orders.status = ? OR orders.status = ?", "paid","complete")
    # order_products = order_products.select do |order_product|
    #   order = Order.find_by(id: order_product.order_id)
    #   order.status == "paid" || order.status == "complete" end
>>>>>>> 4acce3c822b0d3348c1bd0a5e980dc8b5fa2508f
  end

  def total_revenue
    order_products.inject(0) { |sum, order_product| sum + (order_product.quantity * order_product.product.price) }
  end

  def total_by(status)
    order_products.inject(0) {|sum, op| sum + (op.order.status == status ? (op.quantity * op.product.price): 0)}
  end
end
