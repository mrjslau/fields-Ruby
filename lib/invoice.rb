# lib/invoice.rb

# Invoice class objects are invoices for reservations, which can be paid
class Invoice
  attr_reader :reservation, :status, :amount

  def initialize(reservation)
    @reservation = reservation
    @status = 'waiting for payment'
    @amount = reservation.field.price * reservation.time_details[duration]
  end

  
  def pay
    @status = 'paid'
    @reservation.confirm
  end
end
