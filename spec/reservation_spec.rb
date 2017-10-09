# spec/reservation_spec.rb
require 'spec_helper'

describe Reservation do
  let(:client)      { Client.new('s1510766')                 }
  let(:admin)       { Admin.new('adm161616')                 }
  let(:field)       { Field.new('Parc des Princes')          }
  let(:reservation) { Reservation.new(field, client, 10, 15) }

  describe '#accept' do
    context 'when admin accepts' do
      it 'changes reservation status' do
        reservation.accept(admin)
        expect(reservation.status).to eql('accepted')
      end

      it 'sends invoice' do
        expect(reservation.accept(admin)).to be_instance_of(Invoice)
      end
    end
  end

  describe '#cancel' do
    context 'when admin doesn`t approve' do
      it 'changes reservation status' do
        reservation.cancel(admin)
        expect(reservation.status).to eql('canceled')
      end
    end
  end
end
