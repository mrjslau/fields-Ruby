# lib/field.rb

class Field
  attr_accessor :name, :reservations, :res_count
  STATUS_MSG = "Your reservation status is: "

  def initialize(name, reservations = [])
    @name = name
    @reservations = reservations
    @res_count = 0
  end

  def make_reservation(client_id, time)
    @reservations[@res_count] = Reservation.new(client_id, time)
    ret = "#{@reservations[@res_count].status.to_s}"
    @res_count += 1
    puts ret
    return ret

  end
end
