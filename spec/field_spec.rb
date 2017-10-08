# spec/field_spec.rb

describe Field do

let (:client_id) { "c1510766" }
let (:field) { [Field.new("Anfield"), Field.new("Wembley")] }

desribe "#make_reservation" do
  it "creates a new reservation" do
    expect(@field[0].make_reservation(@client_id, "14:30"))to eql("Your reservation status is pending")
  end
end

end
