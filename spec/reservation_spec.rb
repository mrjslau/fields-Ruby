# spec/reservation_spec.rb
require 'spec_helper'

describe Reservation do
  let (:reservation) { Reservation.new }

  describe '#is_completed?' do
    context 'given that it is just created' do
      it 'returns false' do
        expect(@reservation.is_completed?).to be(false)
      end
    end
  end
end
