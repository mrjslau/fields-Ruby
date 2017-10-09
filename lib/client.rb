# lib/client.rb

# Client class objects hold unique id and
# information about accounts of administrators
class Client
  attr_reader :id

  def initialize(id)
    @id = id
  end
end
