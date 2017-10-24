module OrdersHelper

  def subtotal(list)
    return list.inject(0) { |sum,item| sum + item.product.price * item.quantity}
  end

  def total(subtotal)
    return (subtotal*1.10)
  end

  def hide_num(num)
    length_to_hide = num.length - 4
    length_to_hide.times do |n|
      unless num[n] == " "
        num[n] = "*"
      end
    end
    return num
  end

end
