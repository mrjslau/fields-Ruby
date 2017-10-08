# spec/field_spec.rb
require 'spec_helper'

describe Field do
  before do
    @client_id = "s1510766"
    @field = [Field.new("Anfield"), Field.new("Wembley")]
  end

#let (:client_id) { "c1510766" }
#let (:field) { [Field.new("Anfield"), Field.new("Wembley")] }

describe "#make_reservation" do
  it "creates a new pending reservation" do
    msg = "pending"
    expect(@field[0].make_reservation(@client_id, "14:30")).to eql(msg)
  end
end

end
