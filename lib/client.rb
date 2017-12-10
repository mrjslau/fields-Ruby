# lib/client.rb
require 'bcrypt'
require 'yaml'

# Client class objects hold info about users, their current state,
# client can also 'upgrade' to admin
class Client
  attr_reader :credentials, :status

  @clients_loader = Loader.new

  def initialize(id, username, password, email)
    @credentials = {}
    @credentials[:id] = id
    @credentials[:username] = username
    @credentials[:password] = BCrypt::Password.create(password)
    @credentials[:email] = email
    @status = 'offline'
  end

  @all_clients = @clients_loader.load_clients

  def self.all_clients
    @all_clients
  end

  def self.look_for_client(username)
    @all_clients.key?(username)
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
    credentials.fetch(:password) == pass
  end

  def log_in(pass)
    @status = 'Loged' if validate_pass(pass)
  end

  def log_off
    @status = 'offline'
  end

  def convert_to_admin
    admin = Admin.new(self)
    @credentials = nil
    admin
  end
end
