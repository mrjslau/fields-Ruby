# lib/reservation.rb

class Reservation
     attr_accessor :client_id, :time, :status

     def initialize(client_id, time, status = "pending")
       @client_id = client_id
       @time = time
       @status = status
     end

end
