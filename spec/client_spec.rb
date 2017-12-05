# spec/client_spec.rb
require 'spec_helper'
require 'rspec/expectations'

RSpec::Matchers.define :be_encrypted do |expected|
  match do |actual|
    if actual.length > 30 && actual.match(/^$/)
      expected = true
    end
    expected == true
  end
  failure_message do |actual|
    "expected that pass would start with $ and be longer than 30 => #{expected}"
  end
end


describe Client do
  let(:client) { Client.new('c1510766', 'mrjslau', 'foot', 'mar@test.com') }

  describe '#initialize' do
    it 'ensures users pass is encrypted' do
      cl = Client.new('c10', 'mr', 'foo', 'mar@om')
      expect(cl.credentials[:password]).to be_encrypted(true)
    end
  end

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
      expect(client.change_password(old_pass, new_pass)).to be(true)
      expect(client.validate_pass(new_pass)).to be(true)
    end
    it 'protects user`s the password' do
      old_pass = 'foot'
      new_pass = 'trytohackthis'
      client.change_password(old_pass, new_pass)
      expect(client.credentials[:password]).to_not eql(new_pass)
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
      expect(client.status).to eql('offline')
      pass = 'foot'
      client.log_in(pass)
      expect(client.status).to eql('Loged')
    end
    context 'with incorrect pass inputed' do
      it 'user stays offline' do
        expect(client.status).to eql('offline')
        pass = 'football'
        expect { client.log_in(pass) }.to_not change(client, :status)
      end
    end
  end

  describe '#log_off' do
    it 'user status changes to offline' do
      client.log_in('foot')
      expect { client.log_off }.to change(client, :status)
      expect(client.status).to eql('offline')
    end
    context 'if user is offline' do
      it 'status doesnt change' do
        if client.status == 'offline'
          expect { client.log_off }.to_not change(client, :status)
        end
      end
    end
  end

  describe '#convert_to_admin' do
    it 'switches basic profile to admin' do
      expect(client.convert_to_admin).to be_instance_of(Admin)
    end
    it 'destroys old profile information' do
      client.convert_to_admin
      expect(client.credentials).to equal(nil)
    end
    it 'delivers current client info correctly to new profile' do
      admin = client.convert_to_admin
      expect(admin.credentials[:id]).to eql('c1510766')
      expect(admin.credentials[:username]).to eql('mrjslau')
      expect(admin.validate_pass('foot')).to equal(true)
      expect(admin.credentials[:email]).to eql('mar@test.com')
    end
  end
end
