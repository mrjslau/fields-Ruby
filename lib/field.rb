# lib/field.rb

class Field
  attr_accessor :name, :reservations, :res_count
  STATUS_MSG = "Your reservation status is: "

  def initialize(name, reservations = [])
    @name = name
    @reservations = reservations
    @res_count = 0
  end

  def make_reservation(client, time)
    @reservations[@res_count] = Reservation.new(client, time)
    ret = "#{@reservations[@res_count].status.to_s}"
    @res_count += 1
    return ret

  end
end
