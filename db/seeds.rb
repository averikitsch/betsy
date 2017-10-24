require 'csv'

CATEGORY_FILE = Rails.root.join('db','seed-data', 'category-seeds.csv')
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.id = row['id']
  category.name = row['name']
  puts "Created category: #{category.inspect}"
  successful = category.save
  if !successful
    category_failures << category
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categorys failed to save"
puts
puts

ORDER_FILE = Rails.root.join('db','seed-data', 'order-seeds.csv')
puts "Loading raw order data from #{ORDER_FILE}"

order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  order.id = row['id']
  order.status = row['status']
  order.email = row['email']
  order.address = row['address']
  order.name = row['name']
  order.cc_num = row['cc_num']
  order.cc_expiry = row['cc_ex']
  order.cc_cvv = row['cc_cvv']
  order.billing_zip = row['zip']
  puts "Created order: #{order.inspect}"
  successful = order.save
  if !successful
    order_failures << order
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"
puts
puts

USER_FILE = Rails.root.join('db','seed-data', 'user-seeds.csv')
puts "Loading raw user data from #{USER_FILE}"

user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.id = row['id']
  user.username = row['username']
  user.email = row['email']
  user.uid = row['uid']
  user.provider = row['provider']
  puts "Created user: #{user.inspect}"
  successful = user.save
  if !successful
    user_failures << user
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} users failed to save"
puts
puts


PRODUCT_FILE = Rails.root.join('db','seed-data', 'product-seeds.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.id = row['id']
  product.name = row['name']
  product.price = row['price']
  product.stock = row['stock']
  product.description = row['description']
  product.active = row['active']
  product.user_id = row['user_id']
  product.image = row['image']
  puts "Created product: #{product.inspect}"
  successful = product.save
  if !successful
    product_failures << product
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"
puts
puts

REVIEW_FILE = Rails.root.join('db','seed-data', 'review-seeds.csv')
puts "Loading raw review data from #{REVIEW_FILE}"

review_failures = []
CSV.foreach(REVIEW_FILE, :headers => true) do |row|
  review = Review.new
  review.rating = row['rating']
  review.product_id = row['product_id']
  review.body = row['body']
  review.nickname = row['nickname']
  review.location = row['location']
  puts "Created review: #{review.inspect}"
  successful = review.save
  if !successful
    puts review.errors
    review_failures << review
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} reviews failed to save"
puts
puts


OP_FILE = Rails.root.join('db','seed-data', 'order_product-seeds.csv')
puts "Loading raw order_product data from #{OP_FILE}"

order_product_failures = []
CSV.foreach(OP_FILE, :headers => true) do |row|
  order_product = OrderProduct.new
  order_product.quantity= row['quantity']
  order_product.order_id = row['order_id']
  order_product.product_id = row['product_id']
  order_product.shipped = row['shipped']
  puts "Created order_product: #{order_product.inspect}"
  successful = order_product.save
  if !successful
    order_product_failures << order_product
  end
end

puts "Added #{OrderProduct.count} order_product records"
puts "#{order_product_failures.length} order_products failed to save"
puts
puts

puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"


prd = Product.find(11);	cat=Category.find(1);	prd.categories << cat
prd = Product.find(12);	cat=Category.find(1);	prd.categories << cat
prd = Product.find(21);	cat=Category.find(1);	prd.categories << cat
prd = Product.find(22);	cat=Category.find(1);	prd.categories << cat
prd = Product.find(24);	cat=Category.find(1);	prd.categories << cat
prd = Product.find(25);	cat=Category.find(1);	prd.categories << cat
prd = Product.find(6);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(7);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(8);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(10);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(13);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(14);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(15);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(16);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(18);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(19);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(23);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(4);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(22);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(27);	cat=Category.find(2);	prd.categories << cat
prd = Product.find(31);	cat=Category.find(3);	prd.categories << cat
prd = Product.find(32);	cat=Category.find(3);	prd.categories << cat
prd = Product.find(28);	cat=Category.find(3);	prd.categories << cat
prd = Product.find(27);	cat=Category.find(3);	prd.categories << cat
prd = Product.find(8);	cat=Category.find(3);	prd.categories << cat
prd = Product.find(18);	cat=Category.find(3);	prd.categories << cat
prd = Product.find(23);	cat=Category.find(3);	prd.categories << cat
prd = Product.find(8);	cat=Category.find(4);	prd.categories << cat
prd = Product.find(15);	cat=Category.find(4);	prd.categories << cat
prd = Product.find(19);	cat=Category.find(4);	prd.categories << cat
prd = Product.find(30);	cat=Category.find(4);	prd.categories << cat
prd = Product.find(15);	cat=Category.find(5);	prd.categories << cat
prd = Product.find(6);	cat=Category.find(5);	prd.categories << cat
prd = Product.find(20);	cat=Category.find(5);	prd.categories << cat
prd = Product.find(1);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(2);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(3);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(4);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(5);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(9);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(17);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(26);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(22);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(10);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(18);	cat=Category.find(6);	prd.categories << cat
prd = Product.find(20);	cat=Category.find(7);	prd.categories << cat
prd = Product.find(29);	cat=Category.find(7);	prd.categories << cat
prd = Product.find(1);	cat=Category.find(7);	prd.categories << cat
prd = Product.find(2);	cat=Category.find(8);	prd.categories << cat
prd = Product.find(3);	cat=Category.find(8);	prd.categories << cat
