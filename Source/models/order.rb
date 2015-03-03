class Order
  include DataMapper::Resource
  
  property :id,       Serial
  property :order_no, Integer
  property :total,    Numeric, :default => 0, :scale => 2
  property :date,     Date,    :default => DateTime.now.strftime("%m-%d-%Y")
  
  belongs_to :customer

  has n, :shopping_cart, 'OrderLine'
  has n, :products, :through => :shopping_cart
end
