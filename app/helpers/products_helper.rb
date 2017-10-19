module ProductsHelper

  def stock(stock_num)
    if stock_num > 10
      return "in stock"
    elsif stock_num > 0
      return "limited stock"
    else
      return "out of stock"
    end
  end

  def print_categories(list)
    num = list.length - 1
    string = "#{list[0].name}"
    num.times do |i|
      string += ", #{list[i+1].name}"
    end
    return string
  end

  def average_rating(list)
    sum = 0.0
    num = list.length
    list.each do |review|
      sum += review.rating
    end
    average = sum/num
    if average == 0 || average.nil? || average.nan?
      return "The reviews were too scared and ran away"
    else
      return "#{format("%.1f", average)} out of 5"
    end
  end
end
