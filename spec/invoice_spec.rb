# spec/invoice_spec.rb
require 'spec_helper'

describe Invoice do
  let(:client)       { Client.new('s1510766')                                 }
  let(:reservation)  { Reservation.new(Field.new('LOC', 100), client, 21, 20) }
  let(:invoice)      { Invoice.new(reservation)                               }

  describe '#partialy_pay' do
    it 'makes invoice paid partialy'
      inv_msg = 'partial payment'
      invoice.partialy_pay(50)
      expect(invoice.status).to eql(inv_msg)
    end

    it 'deduces partial amount'
      invoice.partialy_pay(50)
      expect(invoice.amount_due).to eql(100)
    end
  end
    
  describe '#pay' do
    it 'makes invoice paid' do
      inv_msg = 'paid'
      invoice.pay
      expect(invoice.status).to eql(inv_msg)
    end

    it 'makes reservation paid' do
      res_msg = 'paid'
      invoice.pay
      expect(invoice.reservation.status).to eql(res_msg)
    end
  end
end
