# lib/invoice.rb

# Invoice class objects are invoices for reservations, which can be paid
class Invoice
  attr_reader :reservation, :status, :amount

  def initialize(reservation, status = 'waiting for payment')
    @reservation = reservation
    @status = status
    @amount = reservation.field.price
  end

  def pay
    @status = 'paid'
    @reservation.confirm
  end
end
