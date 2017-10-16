require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnect do
  include_context 'shared context'

  let(:enet_trap) { %w[Other PortStatus PortThresholds] }
  let(:fc_trap) { %w[Other PortStatus] }
  let(:vcm_trap) { %w[Legacy] }
  let(:trap_sev) { %w[Normal Info Warning Critical Major Minor Unknown] }

  let(:fixture_path) { 'spec/support/fixtures/unit/resource/logical_interconnect_default.json' }
  let(:log_int) { OneviewSDK::LogicalInterconnect.from_file(@client_200, fixture_path) }

  describe '#initialize' do
    it 'requires the enclosure to have a uri value' do
      item = OneviewSDK::LogicalInterconnect.new(@client_200)
      expect(item['type']).to eq('logical-interconnectV3')
    end
  end

  describe '#create' do
    it 'requires the enclosure to have a uri value' do
      expect { log_int.create(1, OneviewSDK::Enclosure.new(@client_200)) }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'makes a POST call to the base uri' do
      expect(@client_200).to receive(:rest_post).with(log_int.class::LOCATION_URI, Hash, log_int.api_version)
                                                .and_return(FakeResponse.new)
      log_int.create(1, OneviewSDK::Enclosure.new(@client_200, uri: '/rest/fake'))
    end
  end

  describe '#delete' do
    it 'requires the enclosure to have a uri value' do
      expect { log_int.delete(1, OneviewSDK::Enclosure.new(@client_200)) }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'makes a DELETE call to the base uri' do
      uri = log_int.class::LOCATION_URI + '?location=Enclosure:/rest/fake,Bay:1'
      expect(@client_200).to receive(:rest_delete).with(uri, {}, log_int.api_version)
                                                  .and_return(FakeResponse.new)
      log_int.delete(1, OneviewSDK::Enclosure.new(@client_200, uri: '/rest/fake'))
    end
  end


  describe '#update_internal_networks' do
    before :each do
      @item = log_int
    end

    it 'updates internal networks without parameters' do
      body = {
        'body' => []
      }
      expect(@client_200).to receive(:rest_put).with(@item['uri'] + '/internalNetworks', body)
                                               .and_return(FakeResponse.new(uri: 'fake'))
      @item.update_internal_networks
      expect(@item['uri']).to eq('fake')
    end

    it 'updates internal networks with parameters' do
      body = {
        'body' => ['rest/fake/ethernet']
      }
      et01 = OneviewSDK::EthernetNetwork.new(@client_200, uri: 'rest/fake/ethernet', name: 'et01')
      expect(@client_200).to receive(:rest_put).with(@item['uri'] + '/internalNetworks', body)
                                               .and_return(FakeResponse.new(uri: 'fake'))
      @item.update_internal_networks(et01)
      expect(@item['uri']).to eq('fake')
    end
  end

  describe '#list_vlan_networks' do
    it 'lists internal networks' do
      item = log_int
      response = {
        'members' => [
          { 'generalNetworkUri' => 'ethernet-network' },
          { 'generalNetworkUri' => 'fc-network' },
          { 'generalNetworkUri' => 'fcoe-network' }
        ]
      }
      allow_any_instance_of(OneviewSDK::EthernetNetwork).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(OneviewSDK::FCNetwork).to receive(:retrieve!).and_return(true)
      allow_any_instance_of(OneviewSDK::FCoENetwork).to receive(:retrieve!).and_return(true)
      expect(@client_200).to receive(:rest_get).with("#{item['uri']}/internalVlans", {}).and_return(true)
      expect(@client_200).to receive(:response_handler).and_return(response)
      result = item.list_vlan_networks
      expect(result).to_not be_empty
      expect(result[0]).to be_instance_of(OneviewSDK::EthernetNetwork)
      expect(result[1]).to be_instance_of(OneviewSDK::FCNetwork)
      expect(result[2]).to be_instance_of(OneviewSDK::FCoENetwork)
      expect(result[0]['uri']).to eq('ethernet-network')
      expect(result[1]['uri']).to eq('fc-network')
      expect(result[2]['uri']).to eq('fcoe-network')
    end
  end

  describe '#update_ethernet_settings' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client_200).update_ethernet_settings }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'requires the ethernetSettings attribute to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client_200, uri: '/rest/fake').update_ethernet_settings }
        .to raise_error(OneviewSDK::IncompleteResource, /Please retrieve/)
    end

    it 'does a PUT to uri/ethernetSettings & updates @data' do
      item = log_int
      expect(@client_200).to receive(:rest_put).with(item['uri'] + '/ethernetSettings', Hash, item.api_version)
                                               .and_return(FakeResponse.new(key: 'val'))
      item.update_ethernet_settings
      expect(item['key']).to eq('val')
    end
  end

  describe '#update_settings' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client_200).update_ethernet_settings }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/settings & updates @data' do
      item = log_int
      expect(@client_200).to receive(:rest_put).with(item['uri'] + '/settings', Hash, item.api_version)
                                               .and_return(FakeResponse.new(key: 'val'))
      item.update_settings
      expect(item['key']).to eq('val')
    end
  end

  describe '#compliance' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client_200).compliance }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/compliance & updates @data' do
      item = log_int
      expect(@client_200).to receive(:rest_put).with(item['uri'] + '/compliance', {}, item.api_version)
                                               .and_return(FakeResponse.new(key: 'val'))
      item.compliance
      expect(item['key']).to eq('val')
    end
  end

  describe '#configuration' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client_200).configuration }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/configuration & updates @data' do
      item = log_int
      expect(@client_200).to receive(:rest_put).with(item['uri'] + '/configuration', {}, item.api_version)
                                               .and_return(FakeResponse.new(key: 'val'))
      item.configuration
      expect(item['key']).to eq('val')
    end
  end

  describe '#get_unassigned_uplink_ports_for_port_monitor' do
    it 'requires the uri to be set' do
      item = OneviewSDK::LogicalInterconnect.new(@client_200)
      expect { item.get_unassigned_uplink_ports_for_port_monitor }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'get_unassigned_uplink_ports_for_port_monitor' do
      item = log_int
      expect(@client_200).to receive(:rest_get).with("#{item['uri']}/unassignedUplinkPortsForPortMonitor")
                                               .and_return(FakeResponse.new(members: [{ interconnectName: 'p1' }, { interconnectName: 'p2' }]))
      results = item.get_unassigned_uplink_ports_for_port_monitor
      expect(results).to_not be_empty
      expect(results.first['interconnectName']).to eq('p1')
      expect(results.last['interconnectName']).to eq('p2')
    end
  end

  describe '#update_port_monitor' do
    it 'raises exception when is not passed the portMonitor' do
      item = OneviewSDK::LogicalInterconnect.new(@client_200, uri: 'rest/fake')
      expect { item.update_port_monitor }
        .to raise_error(OneviewSDK::IncompleteResource, /Please retrieve the Logical Interconnect before trying to update/)
    end

    it 'updates port monitor settings' do
      item = OneviewSDK::LogicalInterconnect.new(@client_200, uri: 'rest/fake', portMonitor: 'rest/fake/d1')
      update_options = {
        'If-Match' =>  item['portMonitor'].delete('eTag'),
        'body' => item['portMonitor']
      }
      expect(@client_200).to receive(:rest_put).with("#{item['uri']}/port-monitor", update_options, item.api_version)
                                               .and_return(true)
      expect(@client_200).to receive(:response_handler).and_return(enablePortMonitor: true)
      expect { item.update_port_monitor }.to_not raise_error
      expect(item['enablePortMonitor']).to be true
    end
  end

  describe '#update_qos_configuration' do
    it 'raises exception when is not passed the qosConfiguration' do
      item = OneviewSDK::LogicalInterconnect.new(@client_200, uri: 'rest/fake')
      expect { item.update_qos_configuration }
        .to raise_error(OneviewSDK::IncompleteResource, /Please retrieve the Logical Interconnect before trying to update/)
    end

    it 'updates QoS aggregated configuration' do
      item = OneviewSDK::LogicalInterconnect.new(@client_200, uri: 'rest/fake', qosConfiguration: { type: 'qos-aggregated-configuration' })
      update_options = {
        'If-Match' =>  item['qosConfiguration'].delete('eTag'),
        'body' => item['qosConfiguration']
      }
      expect(@client_200).to receive(:rest_put).with("#{item['uri']}/qos-aggregated-configuration", update_options, item.api_version)
                                               .and_return(true)
      expect(@client_200).to receive(:response_handler).and_return('activeQosConfig' => { 'type' => 'QosConfiguration' })
      expect { item.update_qos_configuration }.to_not raise_error
      expect(item['activeQosConfig']['type']).to eq('QosConfiguration')
    end
  end

  describe '#update_telemetry_configuration' do
    it 'raises exception when is not passed the telemetryConfiguration' do
      item = OneviewSDK::LogicalInterconnect.new(@client_200, uri: 'rest/fake')
      expect { item.update_telemetry_configuration }
        .to raise_error(OneviewSDK::IncompleteResource, /Please retrieve the Logical Interconnect before trying to update/)
    end

    it 'updates telemetry configuration' do
      options = {
        uri: 'rest/fake',
        telemetryConfiguration: { uri: '/rest/telemetry-configurations/fake' }
      }
      item = OneviewSDK::LogicalInterconnect.new(@client_200, options)
      update_options = {
        'If-Match' =>  item['telemetryConfiguration'].delete('eTag'),
        'body' => item['telemetryConfiguration']
      }
      expect(@client_200).to receive(:rest_put).with(item['telemetryConfiguration']['uri'], update_options, item.api_version)
                                               .and_return(true)
      expect(@client_200).to receive(:response_handler).and_return('telemetryConfiguration' => { 'sampleCount' => 0 })
      expect { item.update_telemetry_configuration }.to_not raise_error
      expect(item['telemetryConfiguration']['sampleCount']).to eq(0)
    end
  end

  describe 'SNMP Configuration' do
    it 'builds the trap options successfully' do
      opt = log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev)
      expect((enet_trap.map { |x| opt['enetTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((fc_trap.map { |x| opt['fcTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((vcm_trap.map { |x| opt['vcmTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((trap_sev.map { |x| opt['trapSeverities'].include?(x) }).include?(false)).to eq(false)
    end

    it 'builds the trap options even with duplicates' do
      new_enet_trap = enet_trap + ['Other']
      new_fc_trap = fc_trap + ['Other']
      new_vcm_trap = vcm_trap + ['Legacy']
      new_trap_sev = trap_sev + ['Critical']
      opt = log_int.generate_trap_options(new_enet_trap, new_fc_trap, new_vcm_trap, new_trap_sev)
      expect((enet_trap.map { |x| opt['enetTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((fc_trap.map { |x| opt['fcTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((vcm_trap.map { |x| opt['vcmTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((trap_sev.map { |x| opt['trapSeverities'].include?(x) }).include?(false)).to eq(false)
    end

    it 'adds one trap destination successfully' do
      opt = log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev)
      log_int.add_snmp_trap_destination('172.18.6.16', 'SNMPv1', 'public', opt)
      entry = log_int['snmpConfiguration']['trapDestinations'].first
      expect(entry['trapDestination']).to eq('172.18.6.16')
      expect(entry['trapFormat']).to eq('SNMPv1')
      expect(entry['communityString']).to eq('public')
    end

    it 'raises exception when is not passed the snmpConfiguration' do
      item = OneviewSDK::LogicalInterconnect.new(@client_200, uri: 'rest/fake')
      expect { item.update_snmp_configuration }
        .to raise_error(OneviewSDK::IncompleteResource, /Please retrieve the Logical Interconnect before trying to update/)
    end

    it 'updates SNMP Configuration' do
      item = OneviewSDK::LogicalInterconnect.new(@client_200, uri: 'rest/fake', snmpConfiguration: { type: 'snmp-configuration' })
      update_options = {
        'If-Match' =>  item['snmpConfiguration'].delete('eTag'),
        'body' => item['snmpConfiguration']
      }
      expect(@client_200).to receive(:rest_put).with("#{item['uri']}/snmp-configuration", update_options, item.api_version)
                                               .and_return(true)
      expect(@client_200).to receive(:response_handler).and_return(enabled: true)
      expect { item.update_snmp_configuration }.to_not raise_error
      expect(item['enabled']).to be true
    end
  end

  describe '#get_firmware' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client_200).get_firmware }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/firmware & returns the result' do
      expect(@client_200).to receive(:rest_get).with(log_int['uri'] + '/firmware').and_return(FakeResponse.new(key: 'val'))
      expect(log_int.get_firmware).to eq('key' => 'val')
    end
  end

  describe '#firmware_update' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client_200).firmware_update(:cmd, nil, {}) }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/firmware & returns the result' do
      expect(@client_200).to receive(:rest_put).with(log_int['uri'] + '/firmware', Hash).and_return(FakeResponse.new(key: 'val'))
      driver = OneviewSDK::FirmwareDriver.new(@client_200, name: 'FW', uri: '/rest/fake')
      expect(log_int.firmware_update('cmd', driver, {})).to eq('key' => 'val')
    end
  end
end
