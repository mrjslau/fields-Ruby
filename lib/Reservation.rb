# lib/reservation.rb

# Reservation class is responsible for managing reservations placed on fields
# and assigning id's
class Reservation
  @@global_res_id = 100_000
  attr_reader :id, :field, :client_id, :day, :time, :status, :acceptor, :invoice

  def initialize(field, client, day, time, status = 'pending')
    @id = @@global_res_id
    @@global_res_id += 1
    @field = field
    @client_id = client.id
    @day = day
    @time = time
    @status = status
  end

  def accept(admin_id, status = 'accepted')
    @acceptor = admin_id
    @status = status
    @invoice = Invoice.new(self)
    @invoice
  end

  def cancel(admin_id, status = 'canceled')
    @acceptor = admin_id
    @status = status
  end

  def confirm(status = 'confirmed and paid')
    @status = status
  end
end
