# spec/invoice_spec.rb
require 'spec_helper'

describe Invoice do
  let(:client)  { Client.new('c1510766', 'mrjslau', 'foot', 'mar@test.com') }
  let(:reserv)  { Reservation.new(Field.new('LOC', 450), client, 21, 20)    }
  let(:invoice) { Invoice.new(reserv)                                       }

  describe '#partialy_pay' do
    it 'makes invoice paid partialy' do
      inv_msg = 'partial payment'
      invoice.partialy_pay(50)
      expect(invoice.status).to eql(inv_msg)
    end

    it 'makes reservation confirmed' do
      res_msg = 'confirmed'
      invoice.partialy_pay(50)
      expect(invoice.reserv.status).to eql(res_msg)
    end

    it 'deduces partial amount' do
      invoice.partialy_pay(50)
      exp = reserv.field.price
      expect(invoice.amount_due).to eql(exp)
    end
  end

  describe '#pay' do
    context 'invoice just created' do
      it 'makes invoice paid' do
        inv_msg = 'waiting for payment'
        expect(invoice.status).to eql(inv_msg)
        inv_msg = 'paid'
        invoice.pay
        expect(invoice.status).to eql(inv_msg)
      end
    end

    it 'makes reservation paid' do
      res_msg = 'confirmed'
      invoice.pay
      expect(invoice.reserv.status).to eql(res_msg)
    end
  end
end
