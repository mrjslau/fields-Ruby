# lib/admin.rb

# Admin class objects hold unique id and
# information about accounts of administrators
class Admin
  attr_reader :id

  def initialize(id)
    @id = id
  end
end
