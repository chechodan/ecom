class OrderLine
  include DataMapper::Resource

  property :id,          Serial
  property :qty,         Integer, :default => 1
  property :unit_price,  Numeric, :scale => 2, :default => 0
  property :total_price, Numeric, :scale => 2, :default => 0

  belongs_to :order,   :key => true
  belongs_to :product, :key => true
end

#DataMapper.finalize
