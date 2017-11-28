# lib/client.rb
require 'bcrypt'

# Client class objects hold info about users, their current state,
# client can also 'upgrade' to admin
class Client
  attr_reader :credentials, :status

  def initialize(id, username, password, email, status = 'offline')
    @credentials = {}
    @credentials[:id] = id
    @credentials[:username] = username
    @credentials[:password] = BCrypt::Password.create(password)
    @credentials[:email] = email
    @status = status
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

  def log_in(pass)
    if validate_pass(pass)
      @status = 'Loged'
    else
      'offline'
    end
  end

  def log_off
    @status = 'offline'
  end
end
