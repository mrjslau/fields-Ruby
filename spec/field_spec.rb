# spec/field_spec.rb
require 'spec_helper'

describe Field do
  let(:client) { Client.new('c1510766')                       }
  let(:field)  { [Field.new('Anfield'), Field.new('Wembley')] }

  describe '#is_available?' do
    context 'client inputs free day' do
      it 'informs it is available' do
        expect(field[0].available?(10, 15)).to be(true)
      end
    end
    context 'client inputs free hour' do
      it 'informs it is available' do
        field[0].make_reservation(client, 10, 12)
        expect(field[0].available?(10, 15)).to be(true)
      end
    end
  end

  describe '#make_reservation' do
    context 'given that field is reserved at that time' do
      it 'notifies client that time isn`t available' do
        field[1].make_reservation(client, 10, 12)
        msg = 'not available'

        expect(field[1].make_reservation(client, 10, 12)).to eql(msg)
      end
    end

    context 'given that field is free whole day' do
      it 'creates a new pending reservation' do
        msg = 'pending'
        expect(field[0].make_reservation(client, 12, 14).status).to eql(msg)
      end
    end

    context 'given that field is free at that time' do
      it 'creates a new pending reservation' do
        msg = 'pending'
        field[0].make_reservation(client, 20, 14)
        field[0].make_reservation(client, 20, 15)
        expect(field[0].timetable[20][15].status).to eql(msg)
      end
    end
  end
end
