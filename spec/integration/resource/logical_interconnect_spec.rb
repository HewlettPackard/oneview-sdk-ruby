require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnect, integration: true do
  include_context 'integration context'

  let(:enclosure) { OneviewSDK::Enclosure.new(@client, name: 'EXAMPLE_ENCLOSURE') }
  let(:log_int) { OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl2-EXAMPLE_LIG') }
  let(:qos_fixture) { 'spec/support/fixtures/integration/logical_interconnect_qos.json' }

  describe '#retrieve!' do
    it 'retrieves the already created necessary objects' do
      expect { enclosure.retrieve! }.to_not raise_error
      expect { log_int.retrieve! }.to_not raise_error
      expect(enclosure[:uri]).to be
      expect(log_int[:type]).to eq('logical-interconnectV3')
    end
  end

  describe '#create' do
    it 'defines the position of the Logical Interconnect' do
      enclosure.retrieve!
      expect { log_int.create(1, enclosure) }.to_not raise_error
    end
  end

  describe '#compliance' do
    it 'defines the position of the Logical Interconnect' do
      log_int.retrieve!
      expect { log_int.compliance }.to_not raise_error
    end
  end

  describe 'Internal Networks Test' do
    before(:each) do
      log_int.retrieve!
    end

    it 'will list the internal networks' do
      vlans = log_int.list_vlan_networks
      expect(vlans).not_to eq(nil)
      expect(vlans.any?).to eq(true)
      vlans.each do |vlan|
        expect(vlan[:name]).to_not eq(nil)
        expect(vlan[:uri]).to_not eq(nil)
      end
    end

    it 'will add and remove new networks' do
      vlans_1 = log_int.list_vlan_networks

      li_et01_options = {
        vlanId:  '2001',
        purpose:  'General',
        name:  'li_et01',
        smartLink:  false,
        privateNetwork:  false,
        connectionTemplateUri: nil,
        type:  'ethernet-networkV3'
      }

      et01 = OneviewSDK::EthernetNetwork.new(@client, li_et01_options)
      et01.create!

      li_et02_options = {
        vlanId:  '2002',
        purpose:  'General',
        name:  'li_et02',
        smartLink:  false,
        privateNetwork:  false,
        connectionTemplateUri: nil,
        type:  'ethernet-networkV3'
      }
      et02 = OneviewSDK::EthernetNetwork.new(@client, li_et02_options)
      et02.create!

      log_int.update_internal_networks(et01, et02)

      vlans_2 = log_int.list_vlan_networks

      log_int.update_internal_networks

      vlans_3 = log_int.list_vlan_networks

      vlans_1.each do |v1|
        expect(vlans_3.include?(v1)).to eq(true)
        expect(vlans_2.include?(v1)).to eq(true)
      end

      vlans_3.each do |v3|
        expect(vlans_1.include?(v3)).to eq(true)
      end

      expect(vlans_3.include?(et01)).to eq(false)
      expect(vlans_3.include?(et02)).to eq(false)

      expect(vlans_2.include?(et01)).to eq(true)
      expect(vlans_2.include?(et02)).to eq(true)

      et01.delete
      et02.delete
    end
  end

  # 00:01:00.640
  describe 'Ethernet settings' do
    it 'will update igmpIdleTimeoutInterval and macRefreshInterval and Rollback' do
      log_int.retrieve!
      eth_set_backup = {}
      eth_set_backup['igmpIdleTimeoutInterval'] = log_int['ethernetSettings']['igmpIdleTimeoutInterval']
      eth_set_backup['macRefreshInterval'] = log_int['ethernetSettings']['macRefreshInterval']
      new_igmp = (eth_set_backup['igmpIdleTimeoutInterval']+237)%501 + 1
      new_mac = (eth_set_backup['macRefreshInterval']+9)%31 + 1

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
      new_igmp = (eth_set_backup['igmpIdleTimeoutInterval']+237)%501 + 1
      new_mac = (eth_set_backup['macRefreshInterval']+9)%31 + 1

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
      log_int.retrieve!

      log_int['qosConfiguration'] = OneviewSDK::LogicalInterconnect.from_file(@client, qos_fixture)['qosConfiguration']
      expect { log_int.update_qos_configuration }.to_not raise_error
      log_int.compliance
    end
  end

  describe 'Telemetry Configuration' do
    it 'will be updated and then will rollback' do
      log_int.retrieve!

      sample_count_bkp = log_int['telemetryConfiguration']['sampleCount']
      sample_interval_bkp = log_int['telemetryConfiguration']['sampleInterval']
      sample_count_new = (sample_count_bkp+137)%301 + 1
      sample_interval_new = (sample_interval_bkp+123)%301 + 1

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
      names = OneviewSDK::LogicalInterconnect.find_by(@client, {}).map { |item| item[:name] }
      expect(names).to include(log_int[:name])
    end

    it 'finds networks by multiple attributes' do
      attrs = { status: 'OK' }
      lis = OneviewSDK::EthernetNetwork.find_by(@client, attrs)
      expect(lis).to_not eq(nil)
    end
  end

  describe 'Update SNMP Configuration' do
    it 'adds one configuration' do
      log_int.retrieve!

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
      expect((enet_trap.map { |x| entry['enetTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((fc_trap.map { |x| entry['fcTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((vcm_trap.map { |x| entry['vcmTrapCategories'].include?(x) }).include?(false)).to eq(false)
      expect((trap_sev.map { |x| entry['trapSeverities'].include?(x) }).include?(false)).to eq(false)
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
      log_int.retrieve!
      expect { log_int.configuration }.to_not raise_error
    end
  end

end
