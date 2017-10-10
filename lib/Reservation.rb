# lib/reservation.rb

# Reservation class is responsible for managing reservations placed on fields
# and assigning id's
class Reservation
  @@class_instance_res_id = 100_000
  attr_reader :id, :field, :client_id, :day, :time, :status, :acceptor

  def initialize(field, client, day, time, status = 'pending')
    @id = @@class_instance_res_id
    @@class_instance_res_id = 1
    @field = field
    @client_id = client.id
    @day = day
    @time = time
    @status = status
  end

  def accept(admin_id, status = 'accepted')
    @acceptor = admin_id
    @status = status
    Invoice.new(self)
  end

  def cancel(admin_id, status = 'canceled')
    @acceptor = admin_id
    @status = status
  end

  def confirm(status = 'confirmed and paid')
    @status = status
  end
end
