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

  def self.look_for_client(username)
    @all_clients.key?(username)
  end

  def self.validate_login(username, pass)
    look_for_client(username) && @all_clients[username].validate_pass(pass)
  end

  def self.add_new_client(id, username, password, email)
    @all_clients[username] = Client.new(id, username, password, email)
    @clients_loader.add_clients_data(id, username, password, email)
  end

  def self.save_clients
    @clients_loader.save_clients_data
  end

  def change_email(new_email)
    @credentials[:email] = new_email
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
