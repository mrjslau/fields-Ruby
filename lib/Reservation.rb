# lib/reservation.rb

class Reservation
     @@global_res_id = 1000000
     attr_accessor :id, :client_id, :time, :status, :acceptor, :invoice

     def initialize(client, time, status = "pending")
       @id = @@global_res_id
       @@global_res_id += 1
       @client_id = client.id
       @time = time
       @status = status
     end

     def accept(admin_id, status = "accepted")
       @acceptor = admin_id
       @status = status
       @invoice = Invoice.new(self)
       return @invoice
     end


end
