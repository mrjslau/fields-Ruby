# spec/field_spec.rb
require 'spec_helper'

describe Field do

let (:client) { Client.new("c1510766") }
let (:field) { [Field.new("Anfield"), Field.new("Wembley")] }

describe "#is_available?" do
  context "client inputs time" do
    it "checks for availability" do
      expect(field.is_available?(15)).to eql(true)
    end
  end
end

describe "#make_reservation" do
  context "given that field is reserved at that time" do
    it "notifies client that time isn`t available" do
      msg = "taken"
      field[1].make_reservation(client, 12)

      expect(field[0].make_reservation(client, 12)).to eql(msg)
    end
  end

  context "given that field is free at that time" do
    it "creates a new pending reservation" do
      msg = "pending"
      expect(field[0].make_reservation(client, 14)).to eql(msg)
    end
  end
end

end
