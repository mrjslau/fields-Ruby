# lib/reservation.rb
require 'yaml'

# Loader class is responsible for
# loading and reading data from YAML files
class Loader
  def load_clients
    data = YAML.load_file(File.join(__dir__, 'clients.yml'))
    clients = {}
    data.each do |name|
      clients[name[0]] = Client.new(
        name[1][:id], name[1][:username], name[1][:pass], name[1][:email]
      )
    end
    clients
  end
end
