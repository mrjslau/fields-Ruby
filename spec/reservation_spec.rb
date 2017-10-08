# spec/reservation_spec.rb
require 'spec_helper'

describe Reservation do
  let (:client) { Client.new(s1510766) }
  let (:admin) { Admin.new(adm161616) }
  let (:reservation) { Reservation.new(client, "15:30", "pending" }

  describe '#accept' do
    context 'admin accepts' do
      it 'changes status' do
        reservation.confirm(@admin)
        expect(@reservation.status).to be("accepted")
      end

      it 'sends invoice' do
        expect(reservation.confirm(@admin))to be_instance_of(Invoice)
      end
    end
  end

 end
end
