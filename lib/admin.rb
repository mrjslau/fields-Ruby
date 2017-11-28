# lib/client.rb
require 'bcrypt'

# Admin class objects hold info about users, who have admin rights
# which include managing fields and accepting reservations,
# and their current state. It is child class of Client
class Admin < Client
  attr_reader :fields

# def initialize(cl)
  # cr = cl.credentials
  # super(cr[:id], cr[:username], cr[:password], cr[:email])
  # fields = nil
# end

  def initialize(cl)
    cr = cl.credentials
    @credentials = {}
    @credentials[:id] = cr[:id]
    @credentials[:username] = cr[:username]
    @credentials[:password] = cr[:password]
    @credentials[:email] = cr[:email]
    @status = cl.status
  end
end
