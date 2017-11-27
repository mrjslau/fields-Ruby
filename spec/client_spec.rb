# spec/client_spec.rb
require 'spec_helper'

describe Client do
  let(:client) { Client.new('c1510766', 'mrjslau', 'foot', 'mar@test.com') }

  describe '#change_email' do
    it 'changes email' do
      newe = 'ig@test.com'
      client.change_email(newe)
      expect(client.credentials[:email]).to eql('ig@test.com')
    end
  end

  describe '#change_password' do
    it 'changes password' do
      old_pass = 'foot'
      new_pass = 'trytohackthis'
      client.change_password(old_pass, new_pass)
      expect(client.validate_pass(new_pass)).to be(true)
    end
    context 'given wrong old pass' do
      it 'returns false' do
        old_pass = 'football'
        new_pass = 'trytohackthis'
        expect(client.change_password(old_pass, new_pass)).to be(false)
        expect(client.validate_pass(new_pass)).to be(false)
      end
    end
  end

  describe '#log_in' do
    it 'changes user`s status' do
      pass = 'foot'
      client.log_in(pass)
      expect(client.status).to eql('Loged')
    end
  end
end
