class User < ApplicationRecord
  has_many :products
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

  def orders
    Order.joins(:products).where('products.user_id = ?', id).distinct
  end

  def order_products
    product_ids = products.collect { |product| product.id }
    order_products = OrderProduct.where(:product_id => product_ids).joins(:order).where("order.status"["paid", "complete"])
    # order_products = order_products.select do |order_product|
    #   order = Order.find_by(id: order_product.order_id)
    #   order.status == "paid" || order.status == "complete" end
  end

  def total_revenue
    order_products.inject(0) do |sum, order_product|
        sum += (order_product.quantity * Product.find_by(id: order_product.product_id).price)
    end
  end
end
