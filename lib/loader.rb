# lib/reservation.rb
require 'yaml'

# Loader class is responsible for
# loading and reading data from YAML files
class Loader
  @clients_data = {}

  def self.clients_data
    @clients_data
  end

  def self.load_clients(path)
    @clients_data = YAML.load_file(File.join(__dir__, path))
    clients = {}
    @clients_data.each do |name|
      creds = name[1]
      clients[name[0]] = Client.new(
        creds[:id], creds[:username], creds[:password], creds[:email]
      )
    end
    clients
  end

  def self.add_clients_data(username, creds)
    @clients_data[username] = creds
  end

  def self.save_clients_data(path)
    output = YAML.dump @clients_data
    File.write(path, output)
  end
end
