# lib/reservation.rb
require 'yaml'

# Loader class is responsible for
# loading and reading data from YAML files
class Loader
  attr_reader :clients_data

  def load_clients
    @clients_data = YAML.load_file(File.join(__dir__, 'clients.yml'))
    clients = {}
    @clients_data.each do |name|
      clients[name[0]] = Client.new(
        name[1][:id], name[1][:username], name[1][:pass], name[1][:email]
      )
      puts name[1][:username]
    end
    clients
  end

  def add_clients_data(id, username, password, email)
    @clients_data[username] = {
       id: id,
       username: username,
       pass: password,
       email: email
     }
  end

  def save_clients_data
    output = YAML.dump @clients_data
    File.write('clients.yml', output)
  end
end
