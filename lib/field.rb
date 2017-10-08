# lib/field.rb

class Field
  attr_accessor :name, :reservations, :res_count

  def initialize(name, reservations = [])
    @name = name
    @reservations = reservations
    @res_count = 0
  end

  def make_reservation(client_id, time)
    @reservations[@res_count] = Reservation.new(client_id, time)
    ret = "Your reservation status is #{@reservations[@res_count-1].status.to_s}"
    @res_count++
    return ret
  end
end
