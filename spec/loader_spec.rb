# spec/loader_spec.rb
require 'spec_helper'

describe Loader do
  let(:prepared_data) do
    {
      'mrjslau' => {
        id: 766,
        username: 'mrjslau',
        password: 'foot',
        email: 'mar@test.com'
      },
      'as' => {
        id: 12,
        username: 'as',
        password: 'as',
        email: 'a@a.lt'
      },
      'tu' => {
        id: 13,
        username: 'tu',
        password: 'tu',
        email: 't@t.lt'
      }
    }
  end

  describe '.load clients' do
    it 'loads correct data from yml file' do
      Loader.load_clients('../yaml/clients.yml')
      expect(Loader.clients_data).to be_eql(prepared_data)
    end
  end
end
