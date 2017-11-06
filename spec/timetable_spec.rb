# spec/field_spec.rb
require 'spec_helper'
  (let(:timetable) { Timetable.new()})

describe Timetable do
  describe '#available?' do
    context 'request with free day' do
      it 'informs it is available' do
        expect(timetable.available?(Date.new(2017,12,24), 15)).to be(true)
      end
    end
    context 'request with free hour' do
      it 'informs it is available' do
        timetable.book(Date.new(2017,12,24), 15))
        expect(timetable.available?(Date.new(2017,12,24), 17)).to be(true)
      end
    end
  end

  describe '#book' do
    it 'books the time if available' do
      timetable.book(Date.new(2017,12,24), 15))
      timetable.table['2017-12-24'][15].should_not be(nil)
    end
    it 'gets notified for unavailability' do
      timetable.book(Date.new(2017,12,24), 15))
      expect(timetable.book(Date.new(2017,12,24), 15)).to be(false)
    end
  end
end
