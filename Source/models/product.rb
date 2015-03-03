class Product
  include DataMapper::Resource

  property :id,          Serial
  property :name,        String,  :required => true, :length => 255
  property :price,       Numeric, :required => true, :scale => 2 
  property :status,      Boolean, :required => true, :default => true 
  property :description, Text,    :required => true

  validates_numericality_of :price
end
