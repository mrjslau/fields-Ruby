# lib/field.rb

class Field
  attr_accessor :name, :reservations, :res_count, :price, :timetable
  STATUS_MSG = "Your reservation status is: "

  def initialize(name, price = 40)
    @name = name
    @reservations = []
    @res_count = 0
    @price = price
    @timetable = []
  end

  def is_available?(day, time)
    if @timetable[day].nil?
      return true
    elsif @timetable[day].has_key?(time) == false
      puts "Ce"
      return true
    else
      puts "ne"
      return false
    end
  end


  def make_reservation(client, day, time)
    if !(self.is_available?(day, time))
      ret = "not available"
      return ret
    end

    if @timetable[day].nil?
      @timetable[day] = Hash.new(time)
      @timetable[day][time] = "taken"
    else
      @timetable[day][time] = "taken"
    end

    @reservations[@res_count] = Reservation.new(self, client, day, time)
    ret = "#{@reservations[@res_count].status.to_s}"
    @res_count += 1
    return ret
  end
end
