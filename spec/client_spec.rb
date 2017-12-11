# spec/client_spec.rb
require 'spec_helper'
require 'rspec/expectations'

RSpec::Matchers.define :be_encrypted do |expected|
  match do |actual|
    expected = true if actual.length > 30 && actual.match(/^$/)
    expected == true
  end
end

RSpec::Matchers.define :be_eql_clients do |expected|
  match do |actual|
    expected.credentials[:id] == actual.credentials[:id] &&
      expected.credentials[:username] == actual.credentials[:username] &&
      expected.credentials[:email] == actual.credentials[:email]
  end
end

describe Client do
  let(:client) { Client.new(766, 'mrjslau', 'foot', 'mar@test.com') }

  describe '.look_for_client' do
    context 'yml file has to be created beforehand' do
      it 'finds client by username' do
        expect(Client.look_for_client('mrjslau')).to be_eql(true)
      end
    end
  end

  describe '.get_client' do
    context 'yml file has to be created beforehand' do
      it 'finds client by username' do
        expect(Client.get_client('mrjslau')).to be_eql_clients(client)
      end
    end
  end

  describe '.validate_login' do
    it 'validates log ins for uis if called' do
      expect(Client.validate_login('mrjslau', 'foot')).to be_eql(true)
    end
  end

  describe '.add_new_client' do
  end

  describe '.save_clients' do
    it 'tells loader class to save all the clients to yaml file' do
      cl = Client.new(20, 'save', 'save', 's@s.lt')
      data = [
        cl.credentials[:id],
        cl.credentials[:username],
        cl.credentials[:pass],
        cl.credentials[:email]
      ]
      Client.add_new_client(data)
      Client.save_clients('yaml/clients.yml')
      saved = Loader.load_clients('../yaml/clients.yml')
      compare = Loader.load_clients('../yaml/compare_save_clients.yml')
      saved.each do |skey, sclient|
        expect(sclient).to be_eql_clients(compare.fetch(skey))
      end
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
      expect(admin.credentials[:id]).to eql(766)
      expect(admin.credentials[:username]).to eql('mrjslau')
      expect(admin.validate_pass('foot')).to equal(true)
      expect(admin.credentials[:email]).to eql('mar@test.com')
    end
  end
end
