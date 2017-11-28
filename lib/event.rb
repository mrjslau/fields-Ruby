# lib/reservation.rb

# Event class is responsible for collecting players after reservation
# adding them to list and for providing info for the players
class Event
  attr_reader :details, :host, :time_details, :players

  def initialize(field, client, time_details)
    @details = {}
    @details[:field] = field
    @details[:time_details] = {}
    @details[:time_details] = time_details
    @host = client
    @players = []
    @players.push(@host)
  end
end
