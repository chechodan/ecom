require 'bcrypt'

class Customer
  include DataMapper::Resource
  
  attr_accessor :passw, :passw_confirmation, :email_confirmation

  property :id,        Serial
  property :firstname, String,     :required => true, :length => 255
  property :lastname,  String,     :required => true, :length => 255
  property :email,     String,     :required => true, :length => 255, :format => :email_address, :unique => true
  property :password,  String,     :required => true, :length => 60,  :writer => :protected

  has n, :orders 

  validates_confirmation_of :email
  validates_length_of :passw, :within => 4..7, :if => :password_required?, :message => "Password must be between 4 and 7 characters long"
  validates_presence_of :passw, :if => :password_required?, :message => "Password must not be blank"
  validates_presence_of :passw_confirmation, :if => :password_required?, :message => "Password Confirmation must not be blank"
  validates_confirmation_of :passw, :if => :password_required?, :message => "Password does not match the confirmation"
  validates_uniqueness_of :email

  before :valid?, :encrypt_password

  def email=(new_email)
    super new_email.to_s.downcase
  end

  def email_confirmation=(new_email)
    @email_confirmation = new_email.to_s.downcase
  end
  
  def password_required?
    new? or passw
  end
  
  def encrypt_password
    self.password = BCrypt::Password.create(passw) if passw
  end

  def password
    value = super
    if value
      BCrypt::Password.new(value)
    else
      nil
    end
  end

  def authenticate(password)
    self.password == password
  end

  def self.authenticate(email, password)
    customer = first(:email => email.to_s.downcase)

    if customer and customer.authenticate(password)
      customer
    else
      nil
    end  
  end
end
