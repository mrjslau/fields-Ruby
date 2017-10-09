# spec/invoice_spec.rb
require 'spec_helper'

describe Invoice do
  let (:client) { Client.new("s1510766") }
  let (:reservation) { Reservation.new(Field.new("Emirates"), @client, "15:30") }
  let (:invoice) { Invoice.new(@reservation)}

  describe '#pay' do
    it 'makes invoice paid' do
      inv_msg = "paid"
      invoice.pay
      expect(invoice.status).to eql(inv_msg)
    end

    it 'makes reservation conf & paid' do
      res_msg = "confirmed and paid"
      invoice.pay
      expect(invoice.reservation.status).to eql(res_msg)
    end
  end

end
