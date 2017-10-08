# lib/invoice.rb

class Invoice
  attr_accessor :reservation, :status

  def initialize(reservation)
    @reservation = reservation
  end

end
