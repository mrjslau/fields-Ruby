# lib/field.rb

# Field class is the main program class
# it contains fields, which can be reserved by clients
class Field
  attr_reader :name, :price, :timetable

  def initialize(name, price = 40)
    @name = name
    @price = price
    @timetable = []
  end

  def available?(day, time)
    if !@timetable[day] || @timetable[day].key?(time) == false
      true
    else
      false
    end
  end

  def make_reservation(client, day, time)
    return 'not available' unless available?(day, time)

    @timetable[day] = Hash.new(time) unless @timetable[day]
    @timetable[day][time] = Reservation.new(self, client, day, time)
  end
end
