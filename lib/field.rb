# lib/field.rb

# Field class is the main program class
# it contains fields, which can be reserved by clients
class Field
  attr_reader :name, :reservations, :res_count, :price, :timetable

  def initialize(name, price = 40)
    @name = name
    @reservations = []
    @res_count = 0
    @price = price
    @timetable = []
  end

  def available?(day, time)
    sel_day = @timetable[day]

    if sel_day.nil? || sel_day.key?(time) == false
      true
    else
      false
    end
  end

  def make_reservation(client, day, time)
    return 'not available' unless available?(day, time)

    @timetable[day] = Hash.new(time) if @timetable[day].nil?

    @timetable[day][time] = 'taken'

    @reservations[@res_count] = Reservation.new(self, client, day, time)
    @res_count += 1
    @reservations[@res_count - 1].status
  end
end
