PROYECT "ECOM"
by Daniel Liendo

   Introduction
   ============

The project implementation is not sorted as I would like. I lack time to do the test. I 'm used to perform the test with implementation. But in this case , I had to leave it for last. Whenever possible, I like to modularize tasks or processes related to be easy to understand in the future (In a few months I forget how I made the implementation). I could not make the payment gateway. Maybe with a day more, the quality of the work is improved.
I tried not to use any additional gem, except DataMapper. I could have used authentication of sinatra, but I understood that you evaluated my performance for the tasks given and without outside assistance.
However, I can say that it was a good experience and fun, because it is my first time using sinatra, and I liked how this tool works. I am more familiar with rails.

Then I will explain how to install the project

   Install 
   =======


1. First of all, is necessary to install the sinatra and datamapper gem. (ref: https://github.com/sinatra/sinatra, http://datamapper.org/getting-started.html)
 
 # Debian / Ubuntu
  sudo apt-get install libmysqlclient-dev
  
 # MacPorts
  sudo port install mysql5
 
  gem install dm-mysql-adapter
  gem install data_mapper
  gem install sinatra
  
2. It is necessary to create the database from the file "SQL/database-ecom.sql". Because I do not use the datamapper migration tool.
3. You need to configure access to the database of the script "seeds.rb" and "ecom.rb" in lines 8 and 10 respectively.
  
   DataMapper.setup(:default, 'mysql://username:password@host/database')

2. Then, you must run the script "Source/seeds.rb" (/$ ruby seeds.rb). This script is used to delete and insert data randomly.
3. Finally, run the "ecom.rb" application (/$ ruby ecom.rb) and voilá.

   Implementation
   ==============

 There isn't much to say. I wanted to generate the structure known as MVC (Model View Controller). However, I only can make a single controller (ecom.rb), (DataMapper) models and views of sinatra.
 
 The achievements were:
  
    * User Login Form
    * User Registration Form.
    * View User Current Orders List.
    * List Products.
    * Add a product to a shopping cart items.
    * Place an order.
    * Add New Products.
    * Edit Existing products

 The remaining are:
 
    * Orders List ordered by date
    * Connect to the payment gateway dummy service.
    * Receive a notification from payment gateway dummy service, if the payment was done successfully.

