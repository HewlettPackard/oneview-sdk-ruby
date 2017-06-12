require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::StorageSystem do
  include_context 'shared context'

  let(:client) { @client_500 }
  let(:empty_item) { described_class.new(client) }

  it 'the UNIQUE_IDENTIFIERS shoud have name, uri and hostname' do
    expect(described_class::UNIQUE_IDENTIFIERS).to eq(%w(name uri hostname))
  end

  it 'inherits from OneviewSDK::API300::C7000::StorageSystem' do
    expect(described_class).to be < OneviewSDK::API300::C7000::StorageSystem
  end

  describe '#initialize' do
    it 'should set default values correctly' do
      expect(empty_item['type']).to eq('StorageSystemV4')
    end
  end

  describe '#get_managed_ports' do
    it 'should return unavailable method' do
      expect { empty_item.get_managed_ports }.to raise_error(OneviewSDK::MethodUnavailable, /The method #get_managed_ports is unavailable/)
    end
  end

  describe '#set_refresh_state' do
    it 'should return unavailable method' do
      expect { empty_item.set_refresh_state }.to raise_error(OneviewSDK::MethodUnavailable, /The method #set_refresh_state is unavailable/)
    end
  end

  describe '#add' do
    it 'should add correctly without managedDomain' do
      item = described_class.new(client, username: 'admin', password: 'secret', hostname: 'hostname.com', family: 'StoreVirtual')
      expected_body = {
        'family' => 'StoreVirtual',
        'hostname' => 'hostname.com',
        'username' => 'admin',
        'password' => 'secret'
      }
      response_body = {
        'credentials' => { 'username' => 'admin', 'password' => 'secret' },
        'family' => 'StoreVirtual',
        'hostname' => 'hostname.com',
        'type' => 'StorageSystemV4'
      }
      fake_resp = FakeResponse.new
      expect(client).to receive(:rest_post).with(described_class::BASE_URI, { 'body' => hash_including(expected_body) }, 500).and_return(fake_resp)
      expect(client).to receive(:response_handler).with(fake_resp).and_return(response_body)
      expect(item).not_to receive(:deep_merge!)
      expect(item).not_to receive(:update)

      item.add

      expect(item.data).to match(response_body)
    end

    context 'when adding a StoreServ' do
      it 'should add correctly without managedDomain' do
        item = described_class.new(client, credentials: { username: 'admin', password: 'secret' }, hostname: 'hostname.com', family: 'StoreServ')
        expected_body = {
          'family' => 'StoreServ',
          'hostname' => 'hostname.com',
          'username' => 'admin',
          'password' => 'secret'
        }
        response_body = {
          'credentials' => { 'username' => 'admin', 'password' => 'secret' },
          'family' => 'StoreServ',
          'hostname' => 'hostname.com',
          'type' => 'StorageSystemV4'
        }
        fake_response = FakeResponse.new
        expect(client).to receive(:rest_post).with(described_class::BASE_URI, { 'body' => expected_body }, 500).and_return(fake_response)
        expect(client).to receive(:response_handler).with(fake_response).and_return(response_body)
        expect(item).not_to receive(:deep_merge!)
        expect(item).not_to receive(:update)

        item.add

        expect(item.data).to match(response_body)
      end

      it 'should add correctly with managedDomain' do
        item = described_class.new(client, credentials: { username: 'admin', password: 'secret' },
                                           hostname: 'hostname.com',
                                           family: 'StoreServ',
                                           deviceSpecificAttributes: { managedDomain: 'TestDomain' })

        expected_body = {
          'family' => 'StoreServ',
          'hostname' => 'hostname.com',
          'username' => 'admin',
          'password' => 'secret'
        }
        response_body = {
          'credentials' => { 'username' => 'admin', 'password' => 'secret' },
          'family' => 'StoreServ',
          'hostname' => 'hostname.com',
          'deviceSpecificAttributes' => { 'managedDomain' => 'TestDomain' },
          'type' => 'StorageSystemV4',
          'uri' => '/rest/storage-systems/UUID-1'
        }
        expected_to_update = {
          'credentials' => { 'username' => 'admin', 'password' => 'secret' },
          'family' => 'StoreServ',
          'hostname' => 'hostname.com',
          'deviceSpecificAttributes' => { 'managedDomain' => 'TestDomain' }
        }
        fake_response = FakeResponse.new
        expect(client).to receive(:rest_post).with(described_class::BASE_URI, { 'body' => expected_body }, 500).and_return(fake_response)
        expect(client).to receive(:response_handler).with(fake_response).and_return(response_body)
        expect(item).to receive(:deep_merge!).with(hash_including(expected_to_update))
        expect(item).to receive(:update).and_return(FakeResponse.new)

        item.add

        expect(item.data).to match(response_body)
      end
    end
  end

  describe '#update' do
    it 'should call correct uri' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      fake_response = FakeResponse.new
      expected_uri = item['uri'] + '/?force=true'
      expect(client).to receive(:rest_put).with(expected_uri, { 'body' => item.data }, 500).and_return(fake_response)
      item.update
    end

    context 'when storage system has not uri' do
      it 'should throw IncompleteResource error' do
        item = described_class.new(client, name: 'without uri')
        expect { item.update }.to raise_error(OneviewSDK::IncompleteResource)
      end
    end
  end

  describe '#remove' do
    it 'should call api with correct header if-match' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      item['eTag'] = 'if-match-value'
      fake_response = FakeResponse.new
      expect(client).to receive(:rest_delete).with(item['uri'], { 'If-Match' => 'if-match-value' }, 500).and_return(fake_response)
      expect(item.remove).to eq(true)
    end

    context 'when storage system has not uri' do
      it 'should throw IncompleteResource error' do
        item = described_class.new(client, name: 'without uri')
        expect { item.remove }.to raise_error(OneviewSDK::IncompleteResource)
      end
    end
  end

  describe '#retrieve!' do
    it 'find by name' do
      item = described_class.new(client, name: 'Fake')
      expect(described_class).to receive(:find_by).with(client, 'name' => 'Fake').and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'find by uri' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      expect(described_class).to receive(:find_by).with(client, 'uri' => '/rest/storage-systems/UUID-1').and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'find by hostname' do
      item = described_class.new(client, hostname: 'hostname.com')
      expect(described_class).to receive(:find_by).with(client, 'hostname' => 'hostname.com').and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'find by wwn' do
      item = described_class.new(client, deviceSpecificAttributes: { wwn: 'ABC123' })
      expect(described_class).to receive(:find_by).with(client, 'deviceSpecificAttributes' => { 'wwn' => 'ABC123' }).and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'find by serialNumber' do
      item = described_class.new(client, deviceSpecificAttributes: { serialNumber: '12345' })
      expect(described_class).to receive(:find_by).with(client, 'deviceSpecificAttributes' => { 'serialNumber' => '12345' }).and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'raises exception when using invalid key' do
      item = described_class.new(client, invalid_key: 'value')
      expect { item.retrieve! }.to raise_error(OneviewSDK::IncompleteResource)
    end

    it 'no parameter given' do
      item = described_class.new(client, {})
      expect { item.retrieve! }.to raise_error(OneviewSDK::IncompleteResource)
    end
  end

  describe '#exists?' do
    it 'verify by name' do
      item = described_class.new(client, name: 'Fake')
      expect(described_class).to receive(:find_by).with(client, 'name' => 'Fake').and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'verify by uri' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      expect(described_class).to receive(:find_by).with(client, 'uri' => '/rest/storage-systems/UUID-1').and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'verify by hostname' do
      item = described_class.new(client, hostname: 'hostname.com')
      expect(described_class).to receive(:find_by).with(client, 'hostname' => 'hostname.com').and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'verify by wwn' do
      item = described_class.new(client, deviceSpecificAttributes: { wwn: 'ABC123' })
      expect(described_class).to receive(:find_by).with(client, 'deviceSpecificAttributes' => { 'wwn' => 'ABC123' }).and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'verify by serialNumber' do
      item = described_class.new(client, deviceSpecificAttributes: { serialNumber: '12345' })
      expect(described_class).to receive(:find_by).with(client, 'deviceSpecificAttributes' => { 'serialNumber' => '12345' }).and_return([item])
      expect(item.retrieve!).to eq(true)
    end

    it 'raises exception when using invalid key' do
      item = described_class.new(client, invalid_key: 'value')
      expect { item.retrieve! }.to raise_error(OneviewSDK::IncompleteResource)
    end

    it 'no parameter given' do
      item = described_class.new(client, {})
      expect { item.retrieve! }.to raise_error(OneviewSDK::IncompleteResource)
    end
  end

  describe '#get_reachable_ports' do
    it 'raises exception when uri is null' do
      expect { described_class.new(client).get_reachable_ports }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets an empty list of reachable ports' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      allow(client).to receive(:response_handler).and_return('members' => [])
      allow(client).to receive(:rest_get).with('/rest/storage-systems/UUID-1/reachable-ports')
      response = item.get_reachable_ports
      expect(response.class).to eq(Array)
      expect(response).to be_empty
    end

    it 'gets a list of reachable ports' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      members = [
        { 'reachableNetworks' => ['/rest/fake/network1', '/rest/fake/network2'] },
        { 'reachableNetworks' => ['/rest/fake/network3', '/rest/fake/network4'] }
      ]

      expect(client).to receive(:response_handler).and_return('members' => members)
      expect(client).to receive(:rest_get).with('/rest/storage-systems/UUID-1/reachable-ports')
      response = item.get_reachable_ports
      expect(response.class).to eq(Array)
      expect(response.size).to eq(2)
      expect(response).to match_array(members)
    end

    it 'gets a list of reachable ports' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      network_1 = OneviewSDK::API500::C7000::FCNetwork.new(client, uri: '/rest/fake/network1')
      network_2 = OneviewSDK::API500::C7000::FCNetwork.new(client, uri: '/rest/fake/network2')
      networks = [network_1, network_2]
      expected_uri = "/rest/storage-systems/UUID-1/reachable-ports?networks='/rest/fake/network1,/rest/fake/network2'"
      expect(described_class).to receive(:find_with_pagination).with(client, expected_uri).and_return('response')
      response = item.get_reachable_ports(networks)
      expect(response).to eq('response')
    end
  end

  describe '#get_templates' do
    it 'should call find_with_pagination correctly' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      expect(described_class).to receive(:find_with_pagination).with(client, item['uri'] + '/templates').and_return('response')
      response = item.get_templates
      expect(response).to eq('response')
    end
  end

  describe '#request_refresh' do
    it 'should call find_with_pagination correctly' do
      item = described_class.new(client, uri: '/rest/storage-systems/UUID-1')
      expected_uri = item['uri'] + '/?force=true'
      expected_body = { 'uri' => '/rest/storage-systems/UUID-1', 'requestingRefresh' => true }
      expect(client).to receive(:rest_put).with(expected_uri, { 'body' => hash_including(expected_body) }, 500).and_return(FakeResponse.new)
      item.request_refresh
    end
  end
end
