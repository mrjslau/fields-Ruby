# spec/admin_spec.rb
require 'spec_helper'

describe Admin do
  let(:client) { Client.new('c1510766', 'mrjslau', 'foot', 'mar@test.com') }
  let(:admin)  { client.convert_to_admin                                   }

  describe '#register_field' do
    it 'crates new field with correct info' do
      new_field = admin.register_field('Old Trafford', 200)
      expect(new_field).to be_instance_of(Field)
      expect(new_field.name).to eql('Old Trafford')
      expect(new_field.price).to eql(200)
    end
    it 'adds new fields to admin`s list' do
      new_field1 = admin.register_field('Old Trafford', 200)
      new_field2 = admin.register_field('Etihad', 100)
      expect(admin.fields).to contain_exactly(new_field1, new_field2)
    end
  end
end
