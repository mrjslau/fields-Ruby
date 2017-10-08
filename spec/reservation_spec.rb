# spec/reservation_spec.rb
require 'spec_helper'

describe Reservation do
  let (:client) { Client.new("s1510766") }
  let (:admin) { Admin.new("adm161616") }
  let (:reservation) { Reservation.new(client, "15:30") }

  describe '#accept' do
    context 'when admin accepts' do
      it 'changes reservation status' do
        reservation.accept(admin)
        expect(reservation.status).to eql("accepted")
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
        expect(reservation.status).to eql("canceled")
      end
    end
  end
end
