# lib/client.rb
require 'bcrypt'
require 'yaml'

# Client class objects hold info about users, their current state,
# client can also 'upgrade' to admin
class Client
  attr_reader :credentials, :status

  def initialize(id, username, password, email)
    @credentials = {}
    @credentials[:id] = id
    @credentials[:username] = username
    @credentials[:password] = BCrypt::Password.create(password)
    @credentials[:email] = email
    @status = 'offline'
  end

  @all_clients = Loader.load_clients('../yaml/clients.yml')

  def self.look_for_client(username)
    @all_clients.key?(username)
  end

  def self.get_client(username)
    @all_clients.fetch(username) if look_for_client(username)
  end

  def self.validate_login(username, pass)
    @all_clients.fetch(username).validate_pass(pass) if look_for_client(username)
  end

  def self.add_new_client(creds)
    Loader.add_clients_data(creds)
    @all_clients[creds.fetch(1)] = new(
      creds.fetch(0), creds.fetch(1), creds.fetch(2), creds.fetch(3)
    )
  end

  def self.save_clients(path = '../yaml/clients.yml')
    Loader.save_clients_data(path)
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
