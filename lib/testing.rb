require_relative 'field'
require_relative 'reservation'

@client_id = "s1510766"
@field = [Field.new("Anfield"), Field.new("Wembley")]

@field[0].make_reservation(@client_id, "14:30")
