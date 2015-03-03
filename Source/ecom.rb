require 'rubygems'
require 'sinatra'
require 'data_mapper'
require './models/customer'
require './models/product'
require './models/order'
require './models/order_line'

configure :development do
  DataMapper.setup(:default, 'mysql://ecom:4GEpUGSQrYhhBDA2@localhost/ecom_development')
  enable :sessions
end

DataMapper.finalize

def authenticate!
  unless session[:current_customer]
    redirect '/login', 303
  end
end

get '/' do
  @products = Product.all(:status => 1)

  erb :products
end

get '/login' do
  erb :login
end

get '/logout' do
  session[:current_customer] = nil
  session[:current_order] = nil
  session.clear

  redirect '/'
end

post '/login' do
  @customer = Customer.authenticate(params[:email], params[:password])
  
  unless @customer
    @error = true
    erb :login  
  else
    session[:current_customer] = @customer
    session[:current_order] = []
  
    redirect '/my_orders'
  end
end

get '/sigin' do
  erb :sigin
end

post '/sigin' do
  @customer = Customer.new(params)
  
  if @customer.save
    session[:current_customer] = @customer
    session[:current_order] = Order.new(:order_no => @customer.orders.length + 1, :customer => @customer)

    redirect '/my_orders'
  else
    @errors = @customer.errors
  
    erb :sigin
  end
end

get '/my_orders' do
  authenticate!

  @customer = session[:current_customer]

  if @customer
    erb :my_orders
  else
    @errors = [['You must login.']]

    erb :errors
  end
end

get '/products' do
  @products = Product.all

  erb :products
end

get '/add_product_to_cart/:id' do
  authenticate!

  current_order = session[:current_order]
  product = Product.get(params[:id])
  
  if product
    index = current_order.index{ |o| o[:product] and o[:product].id == product.id }
    
    if index
      current_order[index][:qty] += 1
      current_order[index][:total_price] += product.price.to_f
    else
      current_order << { :product => product, :qty => 1, :total_price => product.price.to_f }
    end
  else
    redirect '/'    
  end

  redirect '/products'
end

get '/current_order' do
  authenticate!
  
  @current_order = session[:current_order]

  erb :current_order
end

get '/place_order' do
  authenticate!
 
  current_customer = session[:current_customer]
  current_order = session[:current_order]
  
  order = current_customer.orders.create(:order_no => current_customer.orders.count + 1)
  total = 0
  
  current_order.each do |item|
    order.shopping_cart.create(:product => item[:product], :qty => item[:qty], :unit_price => item[:product].price, :total_price => item[:total_price])  
  end
  
  order.total = total
  order.update

  session[:current_order] = []
end

get '/product/add' do
  authenticate!
  
  erb :product
end

post '/product/add' do
  authenticate!
  
  product = Product.new(params)
  
  if product.save
    redirect '/products'
  else
    @errors = product.errors

    erb :product
  end 
end

get '/product/:id/edit' do
  authenticate!
  
  @product = Product.get(params[:id])

  if @product
    erb :edit_product
  else
    @errors = [["No product was found."]]

    erb :errors
  end
end

put '/product/:id/edit' do
  authenticate!
  
  @product = Product.get(params[:id])

  if @product
    @product.update(params[:product])

    redirect '/products'
  else
    @errors = [["No product was found."]]

    erb :errors 
  end 
end
