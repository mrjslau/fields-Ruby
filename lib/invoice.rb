# lib/invoice.rb

class Invoice
  attr_accessor :reservation, :status, :amount

  def initialize(reservation, status = "waiting for payment")
    @reservation = reservation
    @status = status
    @amount = reservation.field.price
  end

  def pay(client_id)
    @status = "paid"
    @reservation.confirm
  end

end
