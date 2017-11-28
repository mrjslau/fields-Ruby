# lib/reservation.rb

# Reservation class is responsible for managing reservations placed on fields
# and assigning id's
class Reservation
  attr_reader :field, :client, :time_details, :status

  def initialize(field, client, day, time, duration = 2)
    @field = field
    @client = client
    @time_details = {}
    @time_details[:day] = day
    @time_details[:time] = time
    @time_details[:duration] = duration
    @status = 'pending'
  end

  def accept
    @status = 'accepted'
    Invoice.new(self)
  end

  def cancel
    @status = 'canceled'
  end

  def confirm
    @status = 'confirmed'
  end

  def create_event
    Event.new(field, client, time_details)
  end
end
