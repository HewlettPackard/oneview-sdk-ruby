require 'spec_helper'

RSpec.describe OneviewSDK::ServerProfile do
  include_context 'shared context'

  before :each do
    @item = described_class.new(@client, name: 'unit_server_profile', uri: 'rest/server-profiles/fake')
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      profile = OneviewSDK::ServerProfile.new(@client)
      expect(profile[:type]).to eq('ServerProfileV5')
    end
  end

  describe '#set_server_hardware' do
    before :each do
      @server_hardware = OneviewSDK::ServerHardware.new(@client, name: 'server_hardware')
      @server_hardware_uri = '/rest/fake/server-hardwares/test'
    end

    it 'will set the serverHardwareUri correctly' do
      @server_hardware['uri'] = @server_hardware_uri
      @item.set_server_hardware(@server_hardware)
      expect(@item['serverHardwareUri']).to eq(@server_hardware_uri)
    end

    it 'will retrieve and set the serverHardwareUri correctly' do
      expect(@client).to receive(:rest_get).with('/rest/server-hardware')
        .and_return(FakeResponse.new(members: [
            { name: 'server_hardware', uri: @server_hardware_uri },
            { name: 'wrong_server_hardware', uri: 'wrong_uri' }
          ]))
      @item.set_server_hardware(@server_hardware)
      expect(@item['serverHardwareUri']).to eq(@server_hardware_uri)
    end

    it 'will fail to put serverHardwareUri since the resource does not exists' do
      expect(@client).to receive(:rest_get).with('/rest/server-hardware')
        .and_return(FakeResponse.new(members: [
            { name: 'wrong_server_hardware', uri: 'wrong_uri' }
          ]))
      expect { @item.set_server_hardware(@server_hardware) }.to raise_error(/could not be found/)
    end
  end

  describe '#set_server_hardware_type' do
    before :each do
      @server_hardware_type = OneviewSDK::ServerHardwareType.new(@client, name: 'server_hardware_type')
      @server_hardware_type_uri = '/rest/fake/server-hardware-types/test'
    end

    it 'will set the serverHardwareTypeUri correctly' do
      @server_hardware_type['uri'] = @server_hardware_type_uri
      @item.set_server_hardware_type(@server_hardware_type)
      expect(@item['serverHardwareTypeUri']).to eq(@server_hardware_type_uri)
    end

    it 'will retrieve and set the serverHardwareTypeUri correctly' do
      expect(@client).to receive(:rest_get).with('/rest/server-hardware-types')
        .and_return(FakeResponse.new(members: [
            { name: 'server_hardware_type', uri: @server_hardware_type_uri },
            { name: 'wrong_server_hardware_type', uri: 'wrong_uri' }
          ]))
      @item.set_server_hardware_type(@server_hardware_type)
      expect(@item['serverHardwareTypeUri']).to eq(@server_hardware_type_uri)
    end

    it 'will fail to put serverHardwareTypeUri since the resource does not exists' do
      expect(@client).to receive(:rest_get).with('/rest/server-hardware-types')
        .and_return(FakeResponse.new(members: [
            { name: 'wrong_server_hardware_type', uri: 'wrong_uri' }
          ]))
      expect { @item.set_server_hardware_type(@server_hardware_type) }.to raise_error(/could not be found/)
    end
  end

  describe '#set_enclosure_group' do
    before :each do
      @enclosure_group = OneviewSDK::EnclosureGroup.new(@client, name: 'enclosure_group')
      @enclosure_group_uri = '/rest/fake/enclosure-groups/test'
    end

    it 'will set the enclosureGroupUri correctly' do
      @enclosure_group['uri'] = @enclosure_group_uri
      @item.set_enclosure_group(@enclosure_group)
      expect(@item['enclosureGroupUri']).to eq(@enclosure_group_uri)
    end

    it 'will retrieve and set the enclosureGroupUri correctly' do
      expect(@client).to receive(:rest_get).with('/rest/enclosure-groups')
        .and_return(FakeResponse.new(members: [
            { name: 'enclosure_group', uri: @enclosure_group_uri },
            { name: 'wrong_enclosure_group', uri: 'wrong_uri' }
          ]))
      @item.set_enclosure_group(@enclosure_group)
      expect(@item['enclosureGroupUri']).to eq(@enclosure_group_uri)
    end

    it 'will fail to put enclosureGroupUri since the resource does not exists' do
      expect(@client).to receive(:rest_get).with('/rest/enclosure-groups')
        .and_return(FakeResponse.new(members: [
            { name: 'wrong_enclosure_group', uri: 'wrong_uri' }
          ]))
      expect { @item.set_enclosure_group(@enclosure_group) }.to raise_error(/could not be found/)
    end
  end

  describe '#set_enclosure' do
    before :each do
      @enclosure = OneviewSDK::Enclosure.new(@client, name: 'enclosure')
      @enclosure_uri = '/rest/fake/enclosures/test'
    end

    it 'will set the enclosureUri correctly' do
      @enclosure['uri'] = @enclosure_uri
      @item.set_enclosure(@enclosure)
      expect(@item['enclosureUri']).to eq(@enclosure_uri)
    end

    it 'will retrieve and set the enclosureUri correctly' do
      expect(@client).to receive(:rest_get).with('/rest/enclosures')
        .and_return(FakeResponse.new(members: [
            { name: 'enclosure', uri: @enclosure_uri },
            { name: 'wrong_enclosure', uri: 'wrong_uri' }
          ]))
      @item.set_enclosure(@enclosure)
      expect(@item['enclosureUri']).to eq(@enclosure_uri)
    end

    it 'will fail to put enclosureUri since the resource does not exists' do
      expect(@client).to receive(:rest_get).with('/rest/enclosures')
        .and_return(FakeResponse.new(members: [
            { name: 'wrong_enclosure', uri: 'wrong_uri' }
          ]))
      expect { @item.set_enclosure(@enclosure) }.to raise_error(/could not be found/)
    end
  end

  describe '#set_firmware_driver' do
    before :each do
      @firmware_uri = '/rest/fake/firmware-drivers/unit'
      @firmware = OneviewSDK::FirmwareDriver.new(@client, name: 'unit_firmware_driver', uri: @firmware_uri)
    end

    it 'will set the FirmwareDriver with options correctly' do
      @item.set_firmware_driver(@firmware, 'manageFirmware' => false)
      expect(@item['firmware']['firmwareBaselineUri']).to eq(@firmware_uri)
      expect(@item['firmware']['manageFirmware']).to eq(false)
    end
  end

  describe '#self.get_available_networks' do
    it 'returns all the available networks' do
      expect(@client).to receive(:rest_get).with("#{OneviewSDK::ServerProfile::BASE_URI}/available-networks?view=unit")
        .and_return(FakeResponse.new(
                      'ethernetNetworks' => [
                        { 'name' => 'unit_ethernet_network_1' },
                        { 'name' => 'unit_ethernet_network_2' }
                      ],
                      'fcNetworks' => [
                        { 'name' => 'unit_fc_network_1' },
                        { 'name' => 'unit_fc_network_2' }
                      ]
        ))
      expect(@client).to receive(:rest_get).with(OneviewSDK::EthernetNetwork::BASE_URI)
        .and_return(FakeResponse.new('name' => 'unit_ethernet_network_1', 'uri' => 'rest/fake/et1'))
      expect(@client).to receive(:rest_get).with(OneviewSDK::EthernetNetwork::BASE_URI)
        .and_return(FakeResponse.new('name' => 'unit_ethernet_network_2', 'uri' => 'rest/fake/et2'))
      expect(@client).to receive(:rest_get).with(OneviewSDK::FCNetwork::BASE_URI)
        .and_return(FakeResponse.new('name' => 'unit_fc_network_1', 'uri' => 'rest/fake/fc1'))
      expect(@client).to receive(:rest_get).with(OneviewSDK::FCNetwork::BASE_URI)
        .and_return(FakeResponse.new('name' => 'unit_fc_network_2', 'uri' => 'rest/fake/fc2'))

      returned_set = OneviewSDK::ServerProfile.get_available_networks(@client, 'view' => 'unit')
      returned_set['ethernet_networks'].each { |ethernet| expect(ethernet['name']).to match(/unit_ethernet_network/) }
      returned_set['fc_networks'].each { |fibre| expect(fibre['name']).to match(/unit_fc_network/) }
    end
  end

  describe '#self.get_available_servers' do
    it 'retrieves available servers based on a query' do
      server_profile_uri = 'rest/fake/server-profiles/unit'
      server_profile = OneviewSDK::ServerProfile.new(@client, name: 'unit_server_profile', uri: server_profile_uri)
      expect(@client).to receive(:rest_get)
        .with("#{OneviewSDK::ServerProfile::BASE_URI}/available-servers?profileUri=#{server_profile_uri}")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(OneviewSDK::ServerProfile.get_available_servers(@client, 'server_profile' => server_profile)['it'])
        .to eq('works')
    end
  end

  describe '#self.get_available_storage_system' do
    it 'retrieves available storage system based on a query' do
      storage_system_uri = 'rest/fake/storage-systems/unit'
      storage_system = OneviewSDK::StorageSystem.new(@client, name: 'unit_storage_system', uri: storage_system_uri)
      expect(@client).to receive(:rest_get)
        .with("#{OneviewSDK::ServerProfile::BASE_URI}/available-storage-system?storageSystemId=unit")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(OneviewSDK::ServerProfile.get_available_storage_system(@client, 'storage_system' => storage_system)['it'])
        .to eq('works')
    end
  end

  describe '#self.get_available_storage_systems' do
    it 'retrieves available storage system based on a query' do
      expect(@client).to receive(:rest_get)
        .with("#{OneviewSDK::ServerProfile::BASE_URI}/available-storage-systems")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(OneviewSDK::ServerProfile.get_available_storage_systems(@client)['it']).to eq('works')
    end
  end

  describe '#self.get_available_targets' do
    it 'retrieves available targets based on a query' do
      expect(@client).to receive(:rest_get)
        .with("#{OneviewSDK::ServerProfile::BASE_URI}/available-targets")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(OneviewSDK::ServerProfile.get_available_targets(@client)['it']).to eq('works')
    end
  end

  describe '#self.get_profile_ports' do
    it 'retrieves profile ports based on a query' do
      expect(@client).to receive(:rest_get)
        .with("#{OneviewSDK::ServerProfile::BASE_URI}/profile-ports")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(OneviewSDK::ServerProfile.get_profile_ports(@client)['it']).to eq('works')
    end
  end

  describe '#get_compliance_preview' do
    it 'shows compliance preview' do
      expect(@client).to receive(:rest_get).with("#{@item['uri']}/compliance-preview")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(@item.get_compliance_preview['it']).to eq('works')
    end
  end

  describe '#get_messages' do
    it 'shows messages' do
      expect(@client).to receive(:rest_get).with("#{@item['uri']}/messages")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(@item.get_messages['it']).to eq('works')
    end
  end

  describe '#get_transformation' do
    it 'transforms an existing profile' do
      expect(@client).to receive(:rest_get).with("#{@item['uri']}/transformation?queryTest=Test")
        .and_return(FakeResponse.new('it' => 'works'))
      expect(@item.get_transformation('query_test' => 'Test')['it']).to eq('works')
    end
  end

  describe '#compliance' do
    it 'transforms an existing profile' do
      expect(@client).to receive(:rest_patch)
        .with(@item['uri'], 'op' => 'replace', 'path' => '/templateCompliance', 'value' => 'Compliant')
        .and_return(FakeResponse.new)
      expect { @item.compliance }.to_not raise_error
    end
  end

  describe '#add_connection' do
    before :each do
      @network = OneviewSDK::EthernetNetwork.new(@client, name: 'unit_ethernet_network', uri: 'rest/fake/ethernet-networks/unit')
    end

    it 'adds simple connection' do
      expect { @item.add_connection(@network, 'name' => 'unit_net') }.to_not raise_error
      expect(@item['connections']).to be
      expect(@item['connections'].first['id']).to eq(1)
      expect(@item['connections'].first['networkUri']).to eq('rest/fake/ethernet-networks/unit')
    end

    it 'adds multiple connections' do
      1.upto(4) do |count|
        @network['uri'] = "#{@network['uri']}_#{count}"
        expect { @item.add_connection(@network, 'name' => "unit_net_#{count}") }.to_not raise_error
      end
      list_of_ids = []
      @item['connections'].each do |connection|
        expect(list_of_ids).not_to include(connection['id'])
        expect(connection['name']).to match(/#{connection['id']}/)
        list_of_ids << connection['id']
      end
    end
  end


  describe '#available_hardware' do
    it 'requires the serverHardwareTypeUri value to be set' do
      expect { OneviewSDK::ServerProfile.new(@client).available_hardware }.to raise_error(/Must set.*serverHardwareTypeUri/)
    end

    it 'requires the enclosureGroupUri value to be set' do
      expect { OneviewSDK::ServerProfile.new(@client, serverHardwareTypeUri: '/rest/fake').available_hardware }
        .to raise_error(/Must set.*enclosureGroupUri/)
    end

    it 'calls #find_by with the serverHardwareTypeUri and enclosureGroupUri' do
      @item = OneviewSDK::ServerProfile.new(@client, serverHardwareTypeUri: '/rest/fake', enclosureGroupUri: '/rest/fake2')
      params = { state: 'NoProfileApplied', serverHardwareTypeUri: @item['serverHardwareTypeUri'], serverGroupUri: @item['enclosureGroupUri'] }
      expect(OneviewSDK::ServerHardware).to receive(:find_by).with(@client, params).and_return([])
      expect(@item.available_hardware).to eq([])
    end
  end

end
