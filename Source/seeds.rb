require 'rubygems'
require 'data_mapper'
require './models/customer'
require './models/product'
require './models/order'
require './models/order_line'

DataMapper.setup(:default, 'mysql://ecom:4GEpUGSQrYhhBDA2@localhost/ecom_development')
DataMapper.finalize

OrderLine.destroy
Order.destroy
Product.destroy
Customer.destroy

passw = '1234'

50.times do |n|  
  Product.create( :name => "Product #{n}", :price => rand( 0.5...99.99 ).round(2), :status => true, :description => "Product #{n} description" )
  puts "Product #{n}"
end

10.times do |n|
  email ="customer#{n}@mail.com"  
  customer = Customer.create( :firstname => "Firstname#{n}", :lastname => "Lastname#{n}", :email => email, :email_confirmation => email, :passw => passw, :passw_confirmation => passw )
  puts "Customer #{n} ---- "
  rand( 1..10 ).times do |m|
    order = customer.orders.create( :order_no => m ) 
    products = ( 1...50 ).to_a.sample rand( 1..10 )
    total = 0

    puts "Order #{m} - Product-Count: #{products.length} --- "
    products.each do |p|  
      product = Product.first(:name => "Product #{p}")
      
      if product
        qty = rand( 1..15 )
        total_price = qty * product.price.to_f
        total_price = total_price.round(2)
        total += total_price
        puts "#{product.name} | #{qty} x #{product.price} = #{total_price} | #{tota1.round(2)}" 
        
        order.shopping_cart.create( :product => product, :qty => qty, :unit_price => product.price, :total_price => total_price )
      else
        puts "Product #{p} not found."
      end
    end
    
    if total
      order.total = total.round(2)
      order.save
    end
  end
end
