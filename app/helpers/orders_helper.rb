module OrdersHelper

  def subtotal(list)
    return list.inject(0) { |sum,item| sum + item.product.price * item.quantity}
  end

  def total(subtotal)
    return (subtotal*1.10)
  end
end
