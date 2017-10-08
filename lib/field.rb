# lib/field.rb

class Field
  attr_accessor :name, :reservations

  def initialize(name, reservations = [])
    @name = name
    @reservations = reservations
  end

  def make_reservation(client_id)
    @reservations.add(Reservation.new(client_id))
    return "Your reservation status is #{@reservations[0].status}"
  end
end
