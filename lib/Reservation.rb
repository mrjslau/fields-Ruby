# lib/reservation.rb

class Reservation
     @@global_res_id = 1000000
     attr_accessor :id, :field, :client_id, :time, :status, :acceptor, :invoice

     def initialize(field, client, time, status = "pending")
       @id = @@global_res_id
       @@global_res_id += 1
       @field = field
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

     def cancel(admin_id, status = "canceled")
       @acceptor = admin_id
       @status = status
     end




end
