require_relative './../spec_helper'
require 'uri'

# Tests for the SCMB module
RSpec.describe OneviewSDK::SCMB do
  include_context 'shared context'

  let(:valid_url) { 'https://ov.example.com' }
  let(:keypair) do
    {
      'base64SSLCertData' => 'cert1',
      'base64SSLKeyData' => 'key1'
    }
  end
  let(:keypair_uri) { '/rest/certificates/client/rabbitmq/keypair/default' }

  describe '::new_connection' do
    let(:con) { double('connection') }

    before :each do
      allow(con).to receive(:start).and_return(con)
      allow(described_class).to receive(:get_or_create_keypair).and_return(keypair)
    end

    it 'creates a Bunny connection with the correct defaults' do
      allow(Bunny).to receive(:new) do |opts|
        expect(opts[:host]).to eq(URI.parse(@client_600.url).host)
        expect(opts[:verify_peer]).to eq(@client_600.ssl_enabled)
        expect(opts[:logger]).to eq(@client_600.logger)
        expect(opts[:tls_cert]).to eq('cert1')
        expect(opts[:tls_key]).to eq('key1')
        con
      end
      expect(described_class.new_connection(@client_600)).to eq(con)
    end

    it 'allows you to override the defaults' do
      allow(Bunny).to receive(:new) do |opts|
        expect(opts[:host]).to eq(URI.parse(@client_600.url).host) # Doesn't actually override the value
        expect(opts[:verify_peer]).to eq(false)
        expect(opts[:tls_cert]).to eq('c2')
        expect(opts[:tls_key]).to eq('k2')
        expect(opts[:key]).to eq('val')
        con
      end
      override_opts = { host: 'fake', verify_peer: false, tls_cert: 'c2', tls_key: 'k2', key: 'val' }
      described_class.new_connection(@client_600, override_opts)
    end
  end

  describe '::get_or_create_keypair' do
    it 'gets the default rabbitmq keypair' do
      expect(@client_600).to receive(:rest_get).with(keypair_uri).and_return(FakeResponse.new(keypair))
      expect(described_class.get_or_create_keypair(@client_600)). to eq(keypair)
    end

    it 'creates the default rabbitmq keypair if it does not exist' do
      resp1 = FakeResponse.new('', 404)
      resp2 = FakeResponse.new(keypair)
      expect(@client_600).to receive(:rest_get).with(keypair_uri).and_return(resp1, resp2)
      expect(@client_600).to receive(:rest_post).with('/rest/certificates/client/rabbitmq', Hash)
                                                .and_return(FakeResponse.new)
      expect(@client_600.logger).to receive(:info).with(/default keypair not found\. Creating it/)
      expect(described_class.get_or_create_keypair(@client_600)). to eq(keypair)
    end
  end

  describe '::new_queue' do
    let(:con) { double('connection') }
    let(:chan) { double('channel') }
    let(:queue) { double('queue') }

    it 'creates an unnamed queue and binds to it' do
      expect(con).to receive(:create_channel).and_return(chan)
      expect(chan).to receive(:queue).and_return(queue)
      expect(queue).to receive(:bind).with('scmb', routing_key: 'scmb.#').and_return(:val)
      expect(described_class.new_queue(con)).to eq(:val)
    end

    it 'accepts a routing key param' do
      expect(con).to receive(:create_channel).and_return(chan)
      expect(chan).to receive(:queue).and_return(queue)
      expect(queue).to receive(:bind).with('scmb', routing_key: 'key').and_return(:val)
      described_class.new_queue(con, 'key')
    end
  end
end
