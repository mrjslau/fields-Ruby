# lib/reservation.rb

# Reservation class is responsible for managing reservations placed on fields
# and assigning id's
class Reservation
  attr_reader :field, :client, :day, :time, :status, :acceptor

  def initialize(field, client, day, time, status = 'pending')
    @field = field
    @client = client
    @day = day
    @time = time
    @status = status
  end

  def self.get
    @class_instance_variable
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
