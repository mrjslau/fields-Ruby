# spec/reservation_spec.rb
require 'spec_helper'

describe Reservation do
  let(:client)      { Client.new('c1510766', 'mrjslau', 'foot', 'm@test.com') }
  # let(:admin)       { Admin.new('adm161616')                 }
  let(:field)       { Field.new('Parc des Princes', 250)                      }
  let(:reservation) { Reservation.new(field, client, 10, 15)                  }

  describe '#accept' do
    context 'when admin accepts pending reservation' do
      it 'changes reservation status' do
        expect(reservation.status).to eql('pending')
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

  describe '#confirm' do
    it 'changes reservation status to confirmed' do
      reservation.confirm
      expect(reservation.status).to eql('confirmed')
    end
  end

  describe '#create_event' do
    it 'creates new event' do
      reservation.confirm
      expect(reservation.create_event).to be_instance_of(Event)
    end
    it 'delivers correct info' do
      reservation.confirm
      ev = reservation.create_event
      expect(ev.host.credentials).to eql(reservation.client.credentials)
      expect(ev.details[:field]).to eql(reservation.field)
      expect(ev.details[:time_details]).to eql(day: 10, time: 15, duration: 2)
    end
  end
end
