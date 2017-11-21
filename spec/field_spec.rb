# spec/field_spec.rb
require 'spec_helper'

describe Field do
  let(:client) { Client.new('c1510766')                            }
  let(:field)  { [Field.new('Anfield'), Field.new('Wembley', 200)] }

  describe '#available?' do
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
    context 'client inputs busy hour' do
      it 'informs it is NOT available' do
        field[0].make_reservation(client, 10, 12)
        expect(field[0].available?(10, 12)).to be(false)
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

    it 'does not overwrite past reservations' do
      day = 10
      field[1].make_reservation(client, day, 12)
      field[1].make_reservation(client, day, 14)
      expect(field[1].timetable[day]).to include(12)
    end

    context 'given that field is free whole day' do
      it 'creates a timetable for the day' do
        day = 10
        time = 12
        field[0].make_reservation(client, day, time)

        expect(field[0].timetable[day]).to include(time)
      end

      it 'creates a new reservation' do
        res = field[0].make_reservation(client, 10, 12)
        expect(res).to be_instance_of(Reservation)
      end

      it 'delivers correct info to reservation' do
        res = field[0].make_reservation(client, 10, 12)
        expect(res.client).to equal(client)
        expect(res.time_details['day']).to equal(10)
        expect(res.time_details['time']).to equal(12)
        expect(res.field.name).to match(/Anf/)
        expect(res.field.price).to be_nil
      end
    end

    context 'given that field is free at that time' do
      it 'creates a new pending reservation with correct info' do
        msg = 'pending'
        day = 20
        time = 15
        field[1].make_reservation(client, day, 14)
        field[1].make_reservation(client, day, time)
        expect(field[1].timetable[day][time].status).to eql(msg)
        expect(field[1].timetable[day][time].field.price).to equal(200)
      end
    end
  end
end
