require 'spec_helper'

RSpec.describe OneviewSDK::ServerProfile do
  include_context 'shared context'

  before :each do
    @item = described_class.new(@client_200, name: 'unit_server_profile', uri: 'rest/server-profiles/fake')
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      profile = OneviewSDK::ServerProfile.new(@client_200)
      expect(profile[:type]).to eq('ServerProfileV5')
    end
  end

  describe '#retrieve!' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', associatedServer: 'as1', serialNumber: 'sn1', serverHardwareUri: 'sh1' },
        { name: 'name2', uri: 'uri2', associatedServer: 'as2', serialNumber: 'sn2', serverHardwareUri: 'sh2' }
      ])
      allow(@client_200).to receive(:rest_get).with(described_class::BASE_URI, {}).and_return(resp)
    end

    it 'retrieves by name' do
      expect(described_class.new(@client_200, name: 'name1').retrieve!).to be true
      expect(described_class.new(@client_200, name: 'fake').retrieve!).to be false
    end

    it 'retrieves by uri' do
      expect(described_class.new(@client_200, uri: 'uri1').retrieve!).to be true
      expect(described_class.new(@client_200, uri: 'fake').retrieve!).to be false
    end

    it 'retrieves by associatedServer' do
      expect(described_class.new(@client_200, associatedServer: 'as1').retrieve!).to be true
      expect(described_class.new(@client_200, associatedServer: 'fake').retrieve!).to be false
    end

    it 'retrieves by serialNumber' do
      expect(described_class.new(@client_200, serialNumber: 'sn1').retrieve!).to be true
      expect(described_class.new(@client_200, serialNumber: 'fake').retrieve!).to be false
    end

    it 'retrieves by serverHardwareUri' do
      expect(described_class.new(@client_200, serverHardwareUri: 'sh1').retrieve!).to be true
      expect(described_class.new(@client_200, serverHardwareUri: 'fake').retrieve!).to be false
    end
  end

  describe '#exists?' do
    before :each do
      resp = FakeResponse.new(members: [
        { name: 'name1', uri: 'uri1', associatedServer: 'as1', serialNumber: 'sn1', serverHardwareUri: 'sh1' },
        { name: 'name2', uri: 'uri2', associatedServer: 'as2', serialNumber: 'sn2', serverHardwareUri: 'sh2' }
      ])
      allow(@client_200).to receive(:rest_get).with(described_class::BASE_URI, {}).and_return(resp)
    end

    it 'finds it by name' do
      expect(described_class.new(@client_200, name: 'name1').exists?).to be true
      expect(described_class.new(@client_200, name: 'fake').exists?).to be false
    end

    it 'finds it by uri' do
      expect(described_class.new(@client_200, uri: 'uri1').exists?).to be true
      expect(described_class.new(@client_200, uri: 'fake').exists?).to be false
    end

    it 'finds it by associatedServer' do
      expect(described_class.new(@client_200, associatedServer: 'as1').exists?).to be true
      expect(described_class.new(@client_200, associatedServer: 'fake').exists?).to be false
    end

    it 'finds it by serialNumber' do
      expect(described_class.new(@client_200, serialNumber: 'sn1').exists?).to be true
      expect(described_class.new(@client_200, serialNumber: 'fake').exists?).to be false
    end

    it 'finds it by serverHardwareUri' do
      expect(described_class.new(@client_200, serverHardwareUri: 'sh1').exists?).to be true
      expect(described_class.new(@client_200, serverHardwareUri: 'fake').exists?).to be false
    end
  end

  describe '#set_server_hardware' do
    before :each do
      @server_hardware = OneviewSDK::ServerHardware.new(@client_200, name: 'server_hardware')
      @server_hardware_uri = '/rest/fake/server-hardwares/test'
    end

    it 'will retrieve and set the serverHardwareUri correctly' do
      expect(@client_200).to receive(:rest_get).with('/rest/server-hardware', {})
        .and_return(FakeResponse.new(members: [
            { name: 'server_hardware', uri: @server_hardware_uri },
            { name: 'wrong_server_hardware', uri: 'wrong_uri' }
          ]))
      @item.set_server_hardware(@server_hardware)
      expect(@item['serverHardwareUri']).to eq(@server_hardware_uri)
    end

    it 'will fail to put serverHardwareUri since the resource does not exists' do
      expect(@client_200).to receive(:rest_get).with('/rest/server-hardware', {})
        .and_return(FakeResponse.new(members: [
            { name: 'wrong_server_hardware', uri: 'wrong_uri' }
          ]))
      expect { @item.set_server_hardware(@server_hardware) }.to raise_error(/could not be found/)
    end
  end

  describe '#set_server_hardware_type' do
    before :each do
      @server_hardware_type = OneviewSDK::ServerHardwareType.new(@client_200, name: 'server_hardware_type')
      @server_hardware_type_uri = '/rest/fake/server-hardware-types/test'
    end

    it 'will retrieve and set the serverHardwareTypeUri correctly' do
      expect(@client_200).to receive(:rest_get).with('/rest/server-hardware-types', {})
        .and_return(FakeResponse.new(members: [
            { name: 'server_hardware_type', uri: @server_hardware_type_uri },
            { name: 'wrong_server_hardware_type', uri: 'wrong_uri' }
          ]))
      @item.set_server_hardware_type(@server_hardware_type)
      expect(@item['serverHardwareTypeUri']).to eq(@server_hardware_type_uri)
    end

    it 'will fail to put serverHardwareTypeUri since the resource does not exists' do
      expect(@client_200).to receive(:rest_get).with('/rest/server-hardware-types', {})
        .and_return(FakeResponse.new(members: [
            { name: 'wrong_server_hardware_type', uri: 'wrong_uri' }
          ]))
      expect { @item.set_server_hardware_type(@server_hardware_type) }.to raise_error(/could not be found/)
    end
  end

  describe '#set_enclosure_group' do
    before :each do
      @enclosure_group = OneviewSDK::EnclosureGroup.new(@client_200, name: 'enclosure_group')
      @enclosure_group_uri = '/rest/fake/enclosure-groups/test'
    end

    it 'will retrieve and set the enclosureGroupUri correctly' do
      expect(@client_200).to receive(:rest_get).with('/rest/enclosure-groups', {})
        .and_return(FakeResponse.new(members: [
            { name: 'enclosure_group', uri: @enclosure_group_uri },
            { name: 'wrong_enclosure_group', uri: 'wrong_uri' }
          ]))
      @item.set_enclosure_group(@enclosure_group)
      expect(@item['enclosureGroupUri']).to eq(@enclosure_group_uri)
    end

    it 'will fail to put enclosureGroupUri since the resource does not exists' do
      expect(@client_200).to receive(:rest_get).with('/rest/enclosure-groups', {})
        .and_return(FakeResponse.new(members: [
            { name: 'wrong_enclosure_group', uri: 'wrong_uri' }
          ]))
      expect { @item.set_enclosure_group(@enclosure_group) }.to raise_error(/could not be found/)
    end
  end

  describe '#set_enclosure' do
    before :each do
      @enclosure = OneviewSDK::Enclosure.new(@client_200, name: 'enclosure')
      @enclosure_uri = '/rest/fake/enclosures/test'
    end

    it 'will retrieve and set the enclosureUri correctly' do
      expect(@client_200).to receive(:rest_get).with('/rest/enclosures', {})
        .and_return(FakeResponse.new(members: [
            { name: 'enclosure', uri: @enclosure_uri },
            { name: 'wrong_enclosure', uri: 'wrong_uri' }
          ]))
      @item.set_enclosure(@enclosure)
      expect(@item['enclosureUri']).to eq(@enclosure_uri)
    end

    it 'will fail to put enclosureUri since the resource does not exists' do
      expect(@client_200).to receive(:rest_get).with('/rest/enclosures', {})
        .and_return(FakeResponse.new(members: [
            { name: 'wrong_enclosure', uri: 'wrong_uri' }
          ]))
      expect { @item.set_enclosure(@enclosure) }.to raise_error(/could not be found/)
    end
  end

  describe '#set_firmware_driver' do
    before :each do
      @firmware_uri = '/rest/fake/firmware-drivers/unit'
      @firmware = OneviewSDK::FirmwareDriver.new(@client_200, name: 'unit_firmware_driver', uri: @firmware_uri)
    end

    it 'will set the FirmwareDriver with options correctly' do
      @item.set_firmware_driver(@firmware, 'manageFirmware' => false)
      expect(@item['firmware']['firmwareBaselineUri']).to eq(@firmware_uri)
      expect(@item['firmware']['manageFirmware']).to eq(false)
    end
  end

  describe '#self.get_available_networks' do
    it 'returns all the available networks' do
      expect(@client_200).to receive(:rest_get).with("#{OneviewSDK::ServerProfile::BASE_URI}/available-networks?view=unit")
        .and_return(FakeResponse.new(
                      'ethernetNetworks' => [
                        { 'name' => 'ethernet_network_1', 'uri' => 'fake1', 'vlan' => 1 },
                        { 'name' => 'ethernet_network_2', 'uri' => 'fake2', 'vlan' => 2 }
                      ],
                      'fcNetworks' => [
                        { 'name' => 'fc_network_1', 'uri' => 'fake3', 'vlan' => 3 },
                        { 'name' => 'fc_network_2', 'uri' => 'fake4', 'vlan' => 4 }
                      ],
                      'networkSets' => [
                        { 'name' => 'network_set_1', 'uri' => 'fake5' }
                      ],
                      'type' => 'fakeType'
        ))

      returned_set = OneviewSDK::ServerProfile.get_available_networks(@client_200, 'view' => 'unit')
      expect(returned_set['ethernetNetworks'].size).to eq(2)
      returned_set['ethernetNetworks'].each { |net| expect(net['name']).to match(/ethernet_network/) }
      expect(returned_set['fcNetworks'].size).to eq(2)
      returned_set['fcNetworks'].each { |net| expect(net['name']).to match(/fc_network/) }
      expect(returned_set['networkSets'].size).to eq(1)
      returned_set['networkSets'].each { |net| expect(net['name']).to match(/network_set/) }
      expect(returned_set['type']).to be_nil
    end
  end

  describe '#self.get_available_servers' do
    it 'retrieves available servers based on a query' do
      server_profile_uri = 'rest/fake/server-profiles/unit'
      server_profile = OneviewSDK::ServerProfile.new(@client_200, name: 'unit_server_profile', uri: server_profile_uri)
      expect(@client_200).to receive(:rest_get)
        .with("#{OneviewSDK::ServerProfile::BASE_URI}/available-servers?profileUri=#{server_profile_uri}")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(OneviewSDK::ServerProfile.get_available_servers(@client_200, 'server_profile' => server_profile)['it'])
        .to eq('works')
    end
  end

  describe '#self.get_available_storage_system' do
    it 'retrieves available storage system based on a query' do
      storage_system_uri = 'rest/fake/storage-systems/unit'
      storage_system = OneviewSDK::StorageSystem.new(@client_200, name: 'unit_storage_system', uri: storage_system_uri)
      expect(@client_200).to receive(:rest_get)
        .with("#{OneviewSDK::ServerProfile::BASE_URI}/available-storage-system?storageSystemId=unit")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(OneviewSDK::ServerProfile.get_available_storage_system(@client_200, 'storage_system' => storage_system)['it'])
        .to eq('works')
    end
  end

  describe '#self.get_available_storage_systems' do
    it 'retrieves available storage system based on a query' do
      fake_response = FakeResponse.new(members: [{ it: 'works' }])
      allow(@client_200).to receive(:rest_get).and_return(fake_response)
      expect(OneviewSDK::ServerProfile.get_available_storage_systems(@client_200).first['it']).to eq('works')
    end
  end

  describe '#self.get_available_targets' do
    it 'retrieves available targets based on a query' do
      expect(@client_200).to receive(:rest_get)
        .with("#{OneviewSDK::ServerProfile::BASE_URI}/available-targets")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(OneviewSDK::ServerProfile.get_available_targets(@client_200)['it']).to eq('works')
    end
  end

  describe '#self.get_profile_ports' do
    it 'retrieves profile ports based on a query' do
      expect(@client_200).to receive(:rest_get)
        .with("#{OneviewSDK::ServerProfile::BASE_URI}/profile-ports")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(OneviewSDK::ServerProfile.get_profile_ports(@client_200)['it']).to eq('works')
    end
  end

  describe '#get_compliance_preview' do
    it 'shows compliance preview' do
      expect(@client_200).to receive(:rest_get).with("#{@item['uri']}/compliance-preview")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(@item.get_compliance_preview['it']).to eq('works')
    end
  end

  describe '#get_messages' do
    it 'shows messages' do
      expect(@client_200).to receive(:rest_get).with("#{@item['uri']}/messages")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(@item.get_messages['it']).to eq('works')
    end
  end

  describe '#get_transformation' do
    it 'transforms an existing profile' do
      expect(@client_200).to receive(:rest_get).with("#{@item['uri']}/transformation?queryTest=Test")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(@item.get_transformation('query_test' => 'Test')['it']).to eq('works')
    end
  end

  describe '#update_from_template' do
    it 'transforms an existing profile' do
      patch_ops = [{ op: 'replace', path: '/templateCompliance', value: 'Compliant' }]
      request = {
        'If-Match' => @item['eTag'],
        'body' => patch_ops
      }
      expect(@client_200).to receive(:rest_patch)
        .with(@item['uri'], request, 200)
        .and_return(FakeResponse.new)
      expect { @item.update_from_template }.to_not raise_error
    end
  end

  describe '#add_connection' do
    before :each do
      @item['connections'] = []
      @network = OneviewSDK::EthernetNetwork.new(@client_200, name: 'unit_ethernet_network', uri: 'rest/fake/ethernet-networks/unit')
    end

    it 'adds simple connection' do
      expect { @item.add_connection(@network, 'name' => 'unit_net') }.to_not raise_error
      expect(@item['connections']).to be
      expect(@item['connections'].first['id']).to eq(0)
      expect(@item['connections'].first['networkUri']).to eq('rest/fake/ethernet-networks/unit')
    end

    it 'adds multiple connections' do
      base_uri = @network['uri']
      1.upto(4) do |count|
        @network['uri'] = "#{@network['uri']}_#{count}"
        expect { @item.add_connection(@network, 'name' => "unit_net_#{count}") }.to_not raise_error
        @network['uri'] = base_uri
      end
      @item['connections'].each do |connection|
        expect(connection['id']).to eq(0)
        expect(connection['name']).to match(/unit_net_/)
      end
    end

    describe '#remove_connection' do
      before :each do
        @item['connections'] = []
        @network = OneviewSDK::EthernetNetwork.new(@client_200, name: 'unit_ethernet_network', uri: 'rest/fake/ethernet-networks/unit')
        base_uri = @network['uri']
        1.upto(5) do |count|
          @network['uri'] = "#{@network['uri']}_#{count}"
          @item.add_connection(@network, 'name' => "unit_con_#{count}")
          @network['uri'] = base_uri
        end
      end

      it 'removes a connection' do
        removed_connection = @item.remove_connection('unit_con_2')
        expect(removed_connection['name']).to eq('unit_con_2')
        expect(removed_connection['networkUri']).to eq("#{@network['uri']}_2")
        @item['connections'].each do |connection|
          expect(connection['name']).to_not eq(removed_connection['name'])
        end
      end

      it 'removes all connections' do
        1.upto(5) do |count|
          removed_connection = @item.remove_connection("unit_con_#{count}")
          expect(removed_connection['name']).to eq("unit_con_#{count}")
          expect(removed_connection['networkUri']).to eq("#{@network['uri']}_#{count}")
          @item['connections'].each do |connection|
            expect(connection['name']).to_not eq(removed_connection['name'])
          end
        end
        expect(@item['connections']).to be_empty
      end

      it 'returns nil if no connection set' do
        @item.data.delete('connections')
        expect(@item.remove_connection('fake')).not_to be
      end

      it 'returns nil if connection does not exists' do
        expect(@item.remove_connection('fake')).not_to be
      end
    end
  end

  describe '#get_server_hardware' do
    it 'returns nil if no hardware is assigned' do
      hw = OneviewSDK::ServerProfile.new(@client_200).get_server_hardware
      expect(hw).to be_nil
    end

    it 'retrieves and returns the hardware if it is assigned' do
      expect_any_instance_of(OneviewSDK::ServerHardware).to receive(:retrieve!).and_return(true)
      hw = OneviewSDK::ServerProfile.new(@client_200, serverHardwareUri: '/rest/fake').get_server_hardware
      expect(hw).to be_a(OneviewSDK::ServerHardware)
    end
  end

  describe '#get_available_networks' do
    it 'calls the #get_available_networks class method' do
      p = OneviewSDK::ServerProfile.new(@client_200, enclosureGroupUri: '/rest/fake', serverHardwareTypeUri: '/rest/fake2')
      query = { enclosure_group_uri: p['enclosureGroupUri'], server_hardware_type_uri: p['serverHardwareTypeUri'] }
      expect(OneviewSDK::ServerProfile).to receive(:get_available_networks).with(@client_200, query).and_return([])
      expect(p.get_available_networks).to eq([])
    end
  end

  describe '#available_hardware' do
    it 'requires the serverHardwareTypeUri value to be set' do
      expect { OneviewSDK::ServerProfile.new(@client_200).get_available_hardware }
        .to raise_error(OneviewSDK::IncompleteResource, /Must set.*serverHardwareTypeUri/)
    end

    it 'requires the enclosureGroupUri value to be set' do
      expect { OneviewSDK::ServerProfile.new(@client_200, serverHardwareTypeUri: '/rest/fake').get_available_hardware }
        .to raise_error(OneviewSDK::IncompleteResource, /Must set.*enclosureGroupUri/)
    end

    it 'calls #find_by with the serverHardwareTypeUri and enclosureGroupUri' do
      @item = OneviewSDK::ServerProfile.new(@client_200, serverHardwareTypeUri: '/rest/fake', enclosureGroupUri: '/rest/fake2')
      params = { state: 'NoProfileApplied', serverHardwareTypeUri: @item['serverHardwareTypeUri'], serverGroupUri: @item['enclosureGroupUri'] }
      expect(OneviewSDK::ServerHardware).to receive(:find_by).with(@client_200, params).and_return([])
      expect(@item.get_available_hardware).to eq([])
    end
  end

  describe 'Volume attachment operations' do
    it 'can call the #add_volume_attachment using a specific already created Volume' do
      options = { uri: '/fake/volume', storagePoolUri: '/fake/storage-pool', storageSystemUri: '/fake/storage-system' }
      fake_response = FakeResponse.new(members: [options])
      expect(@client_200).to receive(:rest_get).with('/rest/storage-volumes').and_return(fake_response)
      volume = OneviewSDK::Volume.new(@client_200, options)
      @item.add_volume_attachment(volume)

      expect(@item['sanStorage']['volumeAttachments'].size).to eq(1)
      va = @item['sanStorage']['volumeAttachments'].first
      expect(va['volumeUri']).to eq(volume['uri'])
      expect(va['volumeStoragePoolUri']).to eq(volume['storagePoolUri'])
      expect(va['volumeStorageSystemUri']).to eq(volume['storageSystemUri'])
    end

    describe 'can call #remove_volume_attachment' do
      it 'and remove attachment with id 0' do
        options = { uri: '/fake/volume', storagePoolUri: '/fake/storage-pool', storageSystemUri: '/fake/storage-system' }
        fake_response = FakeResponse.new(members: [options])
        expect(@client_200).to receive(:rest_get).with('/rest/storage-volumes').and_return(fake_response)
        volume = OneviewSDK::Volume.new(@client_200, options)
        @item.add_volume_attachment(volume, 'id' => 7)
        expect(@item['sanStorage']['volumeAttachments'].size).to eq(1)
        va = @item.remove_volume_attachment(7)
        expect(@item['sanStorage']['volumeAttachments']).to be_empty
        expect(va['volumeUri']).to eq(volume['uri'])
        expect(va['volumeStoragePoolUri']).to eq(volume['storagePoolUri'])
        expect(va['volumeStorageSystemUri']).to eq(volume['storageSystemUri'])
      end

      it 'and return nil if no attachment found' do
        options = { uri: '/fake/volume', storagePoolUri: '/fake/storage-pool', storageSystemUri: '/fake/storage-system' }
        fake_response = FakeResponse.new(members: [options])
        expect(@client_200).to receive(:rest_get).with('/rest/storage-volumes').and_return(fake_response)
        volume = OneviewSDK::Volume.new(@client_200, options)
        @item.add_volume_attachment(volume, 'id' => 7)
        expect(@item['sanStorage']['volumeAttachments'].size).to eq(1)
        va = @item.remove_volume_attachment(5)
        expect(@item['sanStorage']['volumeAttachments']).not_to be_empty
        expect(va).not_to be
      end

      it 'and return nil if there is no attachment' do
        expect(@item['sanStorage']).not_to be
        va = @item.remove_volume_attachment(0)
        expect(@item['sanStorage']['volumeAttachments']).to be_empty
        expect(va).not_to be
      end
    end

    it 'can call #create_volume_with_attachment and generate the data required for a new Volume with attachment' do
      options = { uri: 'fake/storage-pool', storageSystemUri: 'fake/storage-system' }
      fake_response = FakeResponse.new(members: [options])
      expect(@client_200).to receive(:rest_get).with('/rest/storage-pools').and_return(fake_response)

      storage_pool = OneviewSDK::StoragePool.new(@client_200, options)
      volume_options = {
        name: 'TestVolume',
        description: 'Test Volume for Server Profile Volume Attachment',
        provisioningParameters: {
          provisionType: 'Full',
          requestedCapacity: 1024 * 1024 * 1024
        }
      }
      @item.create_volume_with_attachment(storage_pool, volume_options)
      expect(@item['sanStorage']['volumeAttachments'].size).to eq(1)
      va = @item['sanStorage']['volumeAttachments'].first
      expect(va['volumeUri']).not_to be
      expect(va['volumeStorageSystemUri']).not_to be
      expect(va['volumeStoragePoolUri']).to eq('fake/storage-pool')
      expect(va['volumeShareable']).to eq(false)
      expect(va['volumeProvisionedCapacityBytes']).to eq(1024 * 1024 * 1024)
      expect(va['volumeProvisionType']).to eq('Full')
    end
  end

end
