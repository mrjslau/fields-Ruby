# lib/field.rb

class Field
  attr_accessor :name, :reservations, :res_count, :price
  STATUS_MSG = "Your reservation status is: "

  def initialize(name, reservations = [], price = 40)
    @name = name
    @reservations = reservations
    @res_count = 0
    @price = price
  end

  def make_reservation(client, time)
    @reservations[@res_count] = Reservation.new(self, client, time)
    ret = "#{@reservations[@res_count].status.to_s}"
    @res_count += 1
    return ret

  end
end
