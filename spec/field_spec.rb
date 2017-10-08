# spec/field_spec.rb
require 'spec_helper'

describe Field do
=begin
  before do
    @client = Client.new("s1510766")
    @field = [Field.new("Anfield"), Field.new("Wembley")]
  end
=end
let (:client) { Client.new("c1510766") }
let (:field) { [Field.new("Anfield"), Field.new("Wembley")] }

describe "#make_reservation" do
  it "creates a new pending reservation" do
    msg = "pending"
    expect(field[0].make_reservation(client, "14:30")).to eql(msg)
  end
end

end
