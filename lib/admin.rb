# lib/client.rb
require 'bcrypt'

# Admin class objects hold info about users, who have admin rights
# which include managing fields and accepting reservations,
# and their current state. It is child class of Client
class Admin < Client

end
