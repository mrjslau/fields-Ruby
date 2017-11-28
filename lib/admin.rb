# lib/client.rb
require 'bcrypt'

# Admin class objects hold info about users, who have admin rights
# which include managing fields and accepting reservations,
# and their current state. It is child class of Client
class Admin < Client
  attr_reader :fields

  # cia galima idet dar metoda init naujam adminui
  def initialize(cl)
    cr = cl.credentials
    @credentials = {}
    @credentials[:id] = cr[:id]
    @credentials[:username] = cr[:username]
    @credentials[:password] = cr[:password]
    @credentials[:email] = cr[:email]
    @status = cl.status
    @fields = []
  end

  def register_field(name, price)
    new_field = Field.new(name, price)
    add_field(new_field)
    new_field
  end

  def add_field(field)
    fields.push(field)
  end
end
