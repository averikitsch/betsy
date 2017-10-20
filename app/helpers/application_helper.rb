module ApplicationHelper

  def format_price(price)
    "$" + format("%.2f", price)
  end

  def format_date(date)
    ("<span class='date'>" + date.strftime("%A, %b %d") + "</span>").html_safe
  end

  def format_time(time)
    ("<span class='time'>" + time.strftime("%l:%M %P") + "</span>").html_safe
  end

end
