# spec/reservation_spec.rb
require 'spec_helper'

describe Reservation do
  let(:client)      { Client.new('c1510766', 'mrjslau', 'foot', 'm@test.com') }
  # let(:admin)       { Admin.new('adm161616')                 }
  let(:field)       { Field.new('Parc des Princes', 250)                      }
  let(:reservation) { Reservation.new(field, client, 10, 15)                  }

  describe '#accept' do
    context 'when admin accepts' do
      it 'changes reservation status' do
        reservation.accept
        expect(reservation.status).to eql('accepted')
      end

      it 'sends invoice' do
        expect(reservation.accept).to be_instance_of(Invoice)
      end
    end
  end

  describe '#cancel' do
    context 'when admin doesn`t approve' do
      it 'changes reservation status' do
        reservation.cancel
        expect(reservation.status).to eql('canceled')
      end
    end
  end

  describe 'confirm' do
    it 'changes reservation status to confirmed' do
      reservation.confirm
      expect(reservation.status).to eql('confirmed')
    end
  end
end
