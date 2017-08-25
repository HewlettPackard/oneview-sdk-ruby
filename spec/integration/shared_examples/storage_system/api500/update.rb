RSpec.shared_examples 'StorageSystemUpdateExample API500' do
  describe '#update' do
    it 'should update port to have a network correctly' do
      item = described_class.new($client_500, item_attributes)
      item.retrieve!
      fc_network = OneviewSDK::API500::C7000::FCNetwork.find_by($client_500, name: FC_NET_NAME).first

      port = item['ports'].first
      port['expectedNetworkUri'] = fc_network['uri']
      port['expectedNetworkName'] = fc_network['name']
      port['mode'] = 'Managed'
      expect { item.update }.not_to raise_error
      item.refresh

      port = item['ports'].select { |p| p['expectedNetworkUri'] == fc_network['uri'] }.first
      expect(port).to be
      expect(port['mode']).to eq('Managed')
      expect(port['expectedNetworkName']).to eq(fc_network['name'])
    end
  end

  describe '#get_managed_ports' do
    it 'should throw MethodUnavailable error' do
      item = described_class.new($client_500)
      expect { item.get_managed_ports }.to raise_error(OneviewSDK::MethodUnavailable, /The method #get_managed_ports is unavailable/)
    end
  end

  describe '#get_reachable_ports' do
    it 'should get the storage ports that are connected on the specified networks' do
      item = described_class.new($client_500, item_attributes)
      item.retrieve!
      reachable_ports = []
      fc_network = OneviewSDK::API500::C7000::FCNetwork.find_by($client_500, name: FC_NET_NAME).first
      expect { reachable_ports = item.get_reachable_ports }.not_to raise_error
      expect(reachable_ports).not_to be_empty
      expect(reachable_ports.first['expectedNetworkUri']).to eq(fc_network['uri'])
    end
  end

  describe '#get_templates' do
    it 'should get a list of volume templates' do
      item = described_class.new($client_500, item_attributes)
      item.retrieve!
      expect { item.get_templates }.not_to raise_error # TODO
    end
  end

  describe '#retrieve!' do
    it 'should retrieve using wwn' do
      item = described_class.new($client_500, item_attributes)
      item.retrieve!
      wwn = item['deviceSpecificAttributes']['wwn']

      item_retrieved = described_class.new($client_500, 'deviceSpecificAttributes' => { 'wwn' => wwn })
      expect(item_retrieved.retrieve!).to eq(true)
      expect(item_retrieved['uri']).to eq(item['uri'])

      item_retrieved = described_class.new($client_500, deviceSpecificAttributes: { wwn: wwn })
      expect(item_retrieved.retrieve!).to eq(true)
      expect(item_retrieved['uri']).to eq(item['uri'])
    end

    it 'should retrieve using serialNumber' do
      item = described_class.new($client_500, item_attributes)
      item.retrieve!
      serial_number = item['deviceSpecificAttributes']['serialNumber']

      item_retrieved = described_class.new($client_500, 'deviceSpecificAttributes' => { 'serialNumber' => serial_number })
      expect(item_retrieved.retrieve!).to eq(true)
      expect(item_retrieved['uri']).to eq(item['uri'])

      item_retrieved = described_class.new($client_500, deviceSpecificAttributes: { serialNumber: serial_number })
      expect(item_retrieved.retrieve!).to eq(true)
      expect(item_retrieved['uri']).to eq(item['uri'])
    end

    it 'should retrieve using hostname' do
      item = described_class.new($client_500, item_attributes)
      item.retrieve!

      item_retrieved = described_class.new($client_500, 'hostname' => item['hostname'])
      expect(item_retrieved.retrieve!).to eq(true)
      expect(item_retrieved['uri']).to eq(item['uri'])
    end

    context 'when value for retrieve is wrong' do
      it 'should return false and not retrieve data' do
        item_retrieved = described_class.new($client_500, 'deviceSpecificAttributes' => { 'wwn' => 'fake' })
        expect(item_retrieved.retrieve!).to eq(false)

        item_retrieved = described_class.new($client_500, 'deviceSpecificAttributes' => { 'serialNumber' => 'fake' })
        expect(item_retrieved.retrieve!).to eq(false)

        item_retrieved = described_class.new($client_500, 'hostname' => 'fake')
        expect(item_retrieved.retrieve!).to eq(false)
      end
    end
  end

  describe '#exists?' do
    it 'should verify using wwn' do
      item = described_class.new($client_500, item_attributes)
      item.retrieve!
      wwn = item['deviceSpecificAttributes']['wwn']

      item_retrieved = described_class.new($client_500, 'deviceSpecificAttributes' => { 'wwn' => wwn })
      expect(item_retrieved.retrieve!).to eq(true)
      expect(item_retrieved['uri']).to eq(item['uri'])
    end

    it 'should verify using serialNumber' do
      item = described_class.new($client_500, item_attributes)
      item.retrieve!
      serial_number = item['deviceSpecificAttributes']['serialNumber']

      item_retrieved = described_class.new($client_500, 'deviceSpecificAttributes' => { 'serialNumber' => serial_number })
      expect(item_retrieved.retrieve!).to eq(true)
      expect(item_retrieved['uri']).to eq(item['uri'])
    end

    it 'should verify using hostname' do
      item = described_class.new($client_500, item_attributes)
      item.retrieve!

      item_retrieved = described_class.new($client_500, 'hostname' => item['hostname'])
      expect(item_retrieved.retrieve!).to eq(true)
      expect(item_retrieved['uri']).to eq(item['uri'])
    end

    context 'when value for verify if exists? is wrong' do
      it 'should return false' do
        item_retrieved = described_class.new($client_500, 'deviceSpecificAttributes' => { 'wwn' => 'fake' })
        expect(item_retrieved.exists?).to eq(false)

        item_retrieved = described_class.new($client_500, 'deviceSpecificAttributes' => { 'serialNumber' => 'fake' })
        expect(item_retrieved.exists?).to eq(false)

        item_retrieved = described_class.new($client_500, 'hostname' => 'fake')
        expect(item_retrieved.exists?).to eq(false)
      end
    end
  end
end

RSpec.shared_examples 'StorageSystemUpdateExample StoreServ API500' do
  describe '#update' do
    it 'should update managedDomain and managedPools correctly' do
      item = described_class.new($client_500, item_attributes)
      item.retrieve!

      discovered_domains = item['deviceSpecificAttributes']['discoveredDomains']
      expect(discovered_domains.length).to eq(2)
      discovered_pools = item['deviceSpecificAttributes']['discoveredPools']
      expect(discovered_pools).not_to be_empty

      domain = discovered_domains.delete_at(0)
      item['deviceSpecificAttributes']['managedDomain'] = domain
      pool = discovered_pools.delete_at(0)
      item['deviceSpecificAttributes']['managedPools'] = [pool]
      expect { item.update }.not_to raise_error

      item = described_class.new($client_500, item_attributes)
      item.retrieve!
      expect(item['deviceSpecificAttributes']['managedDomain']).to eq(domain)

      storage_pools_managed = item.get_storage_pools.select { |storage_pool| storage_pool['state'] == 'Managed' }
      expect(storage_pools_managed.length).to eq(1)
      expect(storage_pools_managed.first['name']).to eq(pool['name'])
    end
  end

  include_examples 'StorageSystemUpdateExample API500'
end
