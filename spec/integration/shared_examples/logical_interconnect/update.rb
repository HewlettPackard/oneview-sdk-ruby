# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

RSpec.shared_examples 'LogicalInterconnectUpdateExample' do |context_name|
  include_context context_name

  let(:log_int) { described_class.find_by(current_client, name: log_int_name).first }
  let(:enclosure) { enclosure_class.find_by(current_client, name: encl_name).first }
  let(:qos_fixture) { 'spec/support/fixtures/integration/logical_interconnect_qos.json' }
  let(:firmware_path) { 'spec/support/Service Pack for ProLiant' }

  describe '#compliance' do
    it 'defines the position of the Logical Interconnect' do
      expect { log_int.compliance }.to_not raise_error
    end
  end

  describe '#port_monitor' do
    it 'gets a collection of uplink ports eligibles for assignment to an analyzer port' do
      ports = []
      expect { ports = log_int.get_unassigned_uplink_ports_for_port_monitor }.to_not raise_error
      expect(ports).to_not be_empty
    end

    it 'updates the port monitor' do
      port = log_int.get_unassigned_uplink_ports_for_port_monitor.first
      interconnect = interconnect_class.find_by(current_client, name: port['interconnectName']).first
      downlinks = interconnect['ports'].select { |k| k['portType'] == 'Downlink' }
      options = {
        'analyzerPort' => {
          'portUri' => port['uri'],
          'portMonitorConfigInfo' => 'AnalyzerPort'
        },
        'enablePortMonitor' => true,
        'type' => 'port-monitor',
        'monitoredPorts' => [
          {
            'portUri' => downlinks.first['uri'],
            'portMonitorConfigInfo' => 'MonitoredBoth'
          }
        ]
      }

      log_int['portMonitor'] = options
      expect { log_int.update_port_monitor }.to_not raise_error
      log_int.compliance
    end
  end

  describe 'Internal Networks Test' do
    it 'will list the internal networks and verify it only lists the uplink network' do
      networks = log_int.list_vlan_networks
      expect(networks.any?).to eq(true)
      names = networks.map { |item| item[:name] }
      expect(names).to match_array([ETH_NET_NAME, FC_NET_NAME, FC_NET2_NAME])
    end

    it 'will add and remove new networks' do
      vlans_1 = log_int.list_vlan_networks
      et01 = ethernet_class.new(current_client, name: "#{BULK_ETH_NET_PREFIX}_2")
      et02 = ethernet_class.new(current_client, name: "#{BULK_ETH_NET_PREFIX}_3")
      et01.retrieve!
      et02.retrieve!

      log_int.update_internal_networks(et01, et02)
      vlans_2 = log_int.list_vlan_networks

      log_int.update_internal_networks
      vlans_3 = log_int.list_vlan_networks

      vlans_3.each do |v3|
        expect(vlans_1.include?(v3)).to be
      end

      expect(vlans_3.include?(et01)).to_not be
      expect(vlans_3.include?(et02)).to_not be

      expect(vlans_2.include?(et01)).to be
      expect(vlans_2.include?(et02)).to be
    end
  end

  describe 'Ethernet settings' do
    it 'will update igmpIdleTimeoutInterval and macRefreshInterval and Rollback' do
      eth_set_backup = {}
      eth_set_backup['igmpIdleTimeoutInterval'] = log_int['ethernetSettings']['igmpIdleTimeoutInterval']
      eth_set_backup['macRefreshInterval'] = log_int['ethernetSettings']['macRefreshInterval']
      new_igmp = (eth_set_backup['igmpIdleTimeoutInterval'] + 237) % 501 + 1
      new_mac = (eth_set_backup['macRefreshInterval'] + 9) % 31 + 1

      log_int['ethernetSettings']['igmpIdleTimeoutInterval'] = new_igmp
      log_int['ethernetSettings']['macRefreshInterval'] = new_mac
      log_int.update_ethernet_settings

      log_int['ethernetSettings']['igmpIdleTimeoutInterval'] = 0
      log_int['ethernetSettings']['macRefreshInterval'] = 0
      log_int.retrieve!

      expect(log_int['ethernetSettings']['igmpIdleTimeoutInterval']).to eq(new_igmp)
      expect(log_int['ethernetSettings']['macRefreshInterval']).to eq(new_mac)

      log_int['ethernetSettings']['igmpIdleTimeoutInterval'] = eth_set_backup['igmpIdleTimeoutInterval']
      log_int['ethernetSettings']['macRefreshInterval'] = eth_set_backup['macRefreshInterval']
      log_int.update_ethernet_settings

      log_int['ethernetSettings']['igmpIdleTimeoutInterval'] = 0
      log_int['ethernetSettings']['macRefreshInterval'] = 0
      log_int.retrieve!

      log_int.retrieve!
      expect(log_int['ethernetSettings']['igmpIdleTimeoutInterval']).to eq(eth_set_backup['igmpIdleTimeoutInterval'])
      expect(log_int['ethernetSettings']['macRefreshInterval']).to eq(eth_set_backup['macRefreshInterval'])
    end

    it 'will use update settings to do it' do
      log_int.retrieve!
      eth_set_backup = {}
      eth_set_backup['igmpIdleTimeoutInterval'] = log_int['ethernetSettings']['igmpIdleTimeoutInterval']
      eth_set_backup['macRefreshInterval'] = log_int['ethernetSettings']['macRefreshInterval']
      new_igmp = (eth_set_backup['igmpIdleTimeoutInterval'] + 237) % 501 + 1
      new_mac = (eth_set_backup['macRefreshInterval'] + 9) % 31 + 1

      log_int['ethernetSettings']['igmpIdleTimeoutInterval'] = new_igmp
      log_int['ethernetSettings']['macRefreshInterval'] = new_mac
      options = {
        'ethernetSettings' => log_int['ethernetSettings'],
        'fcoeSettings' => {}
      }
      expect { log_int.update_settings(options) }.to_not raise_error

      log_int['ethernetSettings']['igmpIdleTimeoutInterval'] = 0
      log_int['ethernetSettings']['macRefreshInterval'] = 0
      log_int.retrieve!

      expect(log_int['ethernetSettings']['igmpIdleTimeoutInterval']).to eq(new_igmp)
      expect(log_int['ethernetSettings']['macRefreshInterval']).to eq(new_mac)

      log_int.compliance
    end
  end

  describe 'QoS Aggregated Configuration' do
    it 'will be updated from a fixture' do
      log_int['qosConfiguration'] = described_class.from_file(current_client, qos_fixture)['qosConfiguration']
      expect { log_int.update_qos_configuration }.to_not raise_error
      log_int.compliance
    end
  end

  describe '#get_firmware' do
    it 'will retrieve the firmware options' do
      firmware_opt = log_int.get_firmware
      expect(firmware_opt).to be
      expect(firmware_opt['ethernetActivationDelay']).to be
      expect(firmware_opt['ethernetActivationType']).to be
      expect(firmware_opt['fcActivationDelay']).to be
      expect(firmware_opt['fcActivationType']).to be
    end
  end

  describe 'Telemetry Configuration' do
    it 'will be updated and then will rollback' do
      sample_count_bkp = log_int['telemetryConfiguration']['sampleCount']
      sample_interval_bkp = log_int['telemetryConfiguration']['sampleInterval']
      firmware_opt = log_int.get_firmware
      device_type = firmware_opt['interconnects'].first['deviceType']
      sample_count_new = device_type.include?('Virtual Connect SE 16Gb FC Module') ? 24 : (sample_count_bkp + 137) % 301 + 1
      sample_interval_new = device_type.include?('Virtual Connect SE 16Gb FC Module') ? 3600 : (sample_interval_bkp + 123) % 301 + 1

      log_int['telemetryConfiguration']['sampleCount'] = sample_count_new
      log_int['telemetryConfiguration']['sampleInterval'] = sample_interval_new
      log_int.update_telemetry_configuration

      log_int['telemetryConfiguration']['sampleCount'] = 0
      log_int['telemetryConfiguration']['sampleInterval'] = 0
      log_int.retrieve!

      expect(log_int['telemetryConfiguration']['sampleCount']).to eq(sample_count_new)
      expect(log_int['telemetryConfiguration']['sampleInterval']).to eq(sample_interval_new)

      log_int['telemetryConfiguration']['sampleCount'] = sample_count_bkp
      log_int['telemetryConfiguration']['sampleInterval'] = sample_interval_bkp
      log_int.update_telemetry_configuration

      log_int['telemetryConfiguration']['sampleCount'] = 0
      log_int['telemetryConfiguration']['sampleInterval'] = 0
      log_int.retrieve!

      expect(log_int['telemetryConfiguration']['sampleCount']).to eq(sample_count_bkp)
      expect(log_int['telemetryConfiguration']['sampleInterval']).to eq(sample_interval_bkp)
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = described_class.find_by(current_client, {}).map { |item| item[:name] }
      expect(names).to include(log_int[:name])
    end

    it 'finds networks by multiple attributes' do
      attrs = { status: 'OK' }
      lis = ethernet_class.find_by(current_client, attrs)
      expect(lis).to_not eq(nil)
    end
  end

  describe 'Update SNMP Configuration' do
    it 'adds one configuration' do
      # Adding configuration
      log_int['snmpConfiguration']['snmpAccess'].push('172.18.6.15/24')
      enet_trap = %w(PortStatus)
      fc_trap = %w(Other PortStatus)
      vcm_trap = %w(Legacy)
      trap_sev = %w(Normal Warning Critical)
      trap_options = log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev)
      log_int.add_snmp_trap_destination('172.18.6.16', 'SNMPv2', 'public', trap_options)

      # Updating snmpConfiguration
      log_int.update_snmp_configuration
      entry = log_int['snmpConfiguration']['trapDestinations'].first
      expect((enet_trap.map { |x| entry['enetTrapCategories'].include?(x) }).include?(false)).to_not be
      expect((fc_trap.map { |x| entry['fcTrapCategories'].include?(x) }).include?(false)).to_not be
      expect((vcm_trap.map { |x| entry['vcmTrapCategories'].include?(x) }).include?(false)).to_not be
      expect((trap_sev.map { |x| entry['trapSeverities'].include?(x) }).include?(false)).to_not be
      expect(entry['trapDestination']).to eq('172.18.6.16')
      expect(entry['trapFormat']).to eq('SNMPv2')
      expect(entry['communityString']).to eq('public')
    end

    after(:each) do
      log_int.compliance
    end
  end

  describe '#configuration' do
    it 'reapplies configuration to all managed interconnects' do
      expect { log_int.configuration }.to_not raise_error
    end
  end

  # NOTE: This action requires a firmware image to be specified
  describe 'Firmware Updates' do
    xit 'will assure the firmware is present - This action requires a firmware image to be specified' do
      firmware_name = firmware_path.split('/').last
      firmware = firmware_driver_class.new(current_client, name: firmware_name)
      firmware.retrieve!
    end

    context 'perform the actions - This action requires a firmware image to be specified' do
      xit 'Stage' do
        log_int.retrieve!
        firmware_name = firmware_path.split('/').last
        firmware = firmware_driver_class.new(current_client, name: firmware_name)
        firmware.retrieve!
        firmware_opt = log_int.get_firmware
        firmware_opt['ethernetActivationDelay'] = 7
        firmware_opt['ethernetActivationType'] = 'OddEven'
        firmware_opt['fcActivationDelay'] = 7
        firmware_opt['fcActivationType'] = 'Serial'
        firmware_opt['force'] = true
        expect { log_int.firmware_update('Stage', firmware, firmware_opt) }.to_not raise_error
      end

    end
  end

  # ATTENTION: REAL HARDWARE ONLY
  describe 'Manipulating interconnects' do

    def interconnect_find(bay_number, enclosure)
      log_int.retrieve!
      enclosure_match = true
      bay_match = false
      log_int['interconnectMap']['interconnectMapEntries'].each do |interconnect|
        interconnect['location']['locationEntries'].each do |entry|
          enclosure_match = true if enclosure['uri'] == entry['value'] && entry['type'] == 'Enclosure'
          bay_match = true if bay_number.to_s == entry['value'] && entry['type'] == 'Bay'
        end
        return true if enclosure_match && bay_match
      end
      false
    end

    xit '#create the Interconnect in bay 2 - Test with real hardware only' do
      enclosure.retrieve!
      expect { log_int.create(2, enclosure) }.to_not raise_error
      expect(interconnect_find(2, enclosure)).to eq(true)
    end

    # This example will fail if the interconnect is associated with the LIG
    xit '#create, #delete and #create the Interconnect in bay 2 - Test with real hardware only' do
      enclosure.retrieve!
      expect { log_int.create(2, enclosure) }.to_not raise_error
      expect(interconnect_find(2, enclosure)).to eq(true)

      expect { log_int.delete(2, enclosure) }.to_not raise_error
      expect(interconnect_find(2, enclosure)).to eq(false)

      expect { log_int.create(2, enclosure) }.to_not raise_error
      expect(interconnect_find(2, enclosure)).to eq(true)
    end
  end
end
