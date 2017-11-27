# lib/client.rb
require 'bcrypt'

# Client class objects hold unique id and
# information about accounts of administrators
class Client
  attr_reader :credentials

  def initialize(id, username, password, email)
    @credentials = {}
    @credentials[:id] = id
    @credentials[:username] = username
    @credentials[:password] = BCrypt::Password.create(password)
    @credentials[:email] = email
  end

  def change_email(newe)
    @credentials[:email] = newe
  end

  def change_password(old_pass, new_pass)
    if validate_pass(old_pass)
      @credentials[:password] = BCrypt::Password.create(new_pass)
      true
    else
      false
    end
  end

  def validate_pass(pass)
    @credentials[:password] == pass
  end
end
