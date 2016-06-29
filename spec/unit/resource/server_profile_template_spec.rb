require 'spec_helper'

RSpec.describe OneviewSDK::ServerProfileTemplate do
  include_context 'shared context'

  before(:each) do
    @item = OneviewSDK::ServerProfileTemplate.new(@client, name: 'server_profile_template')
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      expect(@item[:type]).to eq('ServerProfileTemplateV1')
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

  describe '#add_connection' do
    before :each do
      @item['connections'] = []
      @network = OneviewSDK::EthernetNetwork.new(@client, name: 'unit_ethernet_network', uri: 'rest/fake/ethernet-networks/unit')
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
        @network = OneviewSDK::EthernetNetwork.new(@client, name: 'unit_ethernet_network', uri: 'rest/fake/ethernet-networks/unit')
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

  describe '#available_hardware' do
    it 'requires the serverHardwareTypeUri value to be set' do
      expect { OneviewSDK::ServerProfileTemplate.new(@client).available_hardware }
        .to raise_error(OneviewSDK::IncompleteResource, /Must set.*serverHardwareTypeUri/)
    end

    it 'requires the enclosureGroupUri value to be set' do
      expect { OneviewSDK::ServerProfileTemplate.new(@client, serverHardwareTypeUri: '/rest/fake').available_hardware }
        .to raise_error(OneviewSDK::IncompleteResource, /Must set.*enclosureGroupUri/)
    end

    it 'calls #find_by with the serverHardwareTypeUri and enclosureGroupUri' do
      @item = OneviewSDK::ServerProfileTemplate.new(@client, serverHardwareTypeUri: '/rest/fake', enclosureGroupUri: '/rest/fake2')
      params = { state: 'NoProfileApplied', serverHardwareTypeUri: @item['serverHardwareTypeUri'], serverGroupUri: @item['enclosureGroupUri'] }
      expect(OneviewSDK::ServerHardware).to receive(:find_by).with(@client, params).and_return([])
      expect(@item.available_hardware).to eq([])
    end
  end

  describe '#new_profile' do
    it 'returns a profile' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new(name: 'NewProfile'))
      expect(@client).to receive(:rest_get).with('/rest/server-profile-templates/fake/new-profile')
      template = OneviewSDK::ServerProfileTemplate.new(@client, name: 'unit_server_profile_template')
      template['uri'] = '/rest/server-profile-templates/fake'
      profile = template.new_profile
      expect(profile.class).to eq(OneviewSDK::ServerProfile)
      expect(profile['name']).to eq("Server_Profile_created_from_#{template['name']}")
    end

    it 'can set the name of a new profile' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new(name: 'NewProfile'))
      template = OneviewSDK::ServerProfileTemplate.new(@client, uri: '/rest/server-profile-templates/fake')
      profile = template.new_profile('NewName')
      expect(profile[:name]).to eq('NewName')
    end
  end
end
