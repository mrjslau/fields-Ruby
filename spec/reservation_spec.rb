require "spec_helper"

describe Reservation do
  before do
    @reservation = Reservation.new
  end

  describe "#is_completed?" do
    context "given that it is just created" do
      it "returns false" do
        expect(@reservation.is_completed?).to eql(false)
      end
    end
  end
end
