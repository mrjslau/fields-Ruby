# lib/invoice.rb

# Invoice class objects are invoices for reservations, which can be paid
class Invoice
  attr_reader :reserv, :status, :amount_due

  def initialize(reserv)
    @reserv = reserv
    @status = 'waiting for payment'
    @amount_due = reserv.field.price * reserv.time_details.fetch(:duration)
  end

  def pay
    @status = 'paid'
    reserv.confirm
  end

  def partialy_pay(percentage)
    @status = 'partial payment'
    @amount_due -= amount_due * percentage / 100
    reserv.confirm
  end
end
