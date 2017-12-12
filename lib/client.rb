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

  def self.validate_login(usrname, pass)
    @all_clients.fetch(usrname).validate_pass(pass) if look_for_client(usrname)
  end

  def self.add_new_client(username, creds)
    Loader.add_clients_data(username, creds)
    @all_clients[username] = new(
      creds.fetch(:id), creds.fetch(:username),
      creds.fetch(:password), creds.fetch(:email)
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
