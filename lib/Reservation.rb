# lib/reservation.rb

class Reservation
     attr_accessor :client_id, :status

     def initialize(client_id, status = "pending")
       @client_id = client_id
       @status = status
     end

end
