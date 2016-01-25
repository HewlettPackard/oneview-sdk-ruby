require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnect, integration: false do
  include_context 'integration context'

  let(:enclosure) { OneviewSDK::Enclosure.new(@client, name: 'Encl2') }
  let(:log_int) { OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl2-Simple') }

  describe '#retrieve!' do
    it 'retrieves the already created necessary objects' do
      expect { enclosure.retrieve! }.to_not raise_error
      expect { log_int.retrieve! }.to_not raise_error
      expect(log_int[:type]).to eq('logical-interconnectV3')
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
      log_int['ethernetSettings']['igmpIdleTimeoutInterval'] = 100
      log_int['ethernetSettings']['macRefreshInterval'] = 1
      log_int.update_ethernet_settings
      log_int.retrieve!
      expect(log_int['ethernetSettings']['igmpIdleTimeoutInterval']).to eq(100)
      expect(log_int['ethernetSettings']['macRefreshInterval']).to eq(1)
      log_int['ethernetSettings']['igmpIdleTimeoutInterval'] -= 50
      log_int['ethernetSettings']['macRefreshInterval'] -= 15
      log_int.update_ethernet_settings
      log_int.retrieve!
      expect(log_int['ethernetSettings']['igmpIdleTimeoutInterval']).to eq(eth_set_backup['igmpIdleTimeoutInterval'])
      expect(log_int['ethernetSettings']['macRefreshInterval']).to eq(eth_set_backup['macRefreshInterval'])
    end
  end

  # describe 'QoS Aggregated Configuration' do
  #   it 'will be updated and then will rollback' do
  #     log_int.retrieve!
  #
  #     uplink_classification_bkp = log_int['qosConfiguration']['activeQosConfig']['configType']
  #     uplink_classification_new = 'NA'
  #
  #     log_int['qosConfiguration']['activeQosConfig']['configType'] = uplink_classification_new
  #     log_int.update_qos_configuration
  #     log_int.retrieve!
  #     expect(log_int['qosConfiguration']['activeQosConfig']['configType']).to eq(uplink_classification_new)
  #
  #     log_int['qosConfiguration']['activeQosConfig']['configType'] = uplink_classification_bkp
  #     log_int.update_qos_configuration
  #     log_int.retrieve!
  #     expect(log_int['qosConfiguration']['activeQosConfig']['configType']).to eq(uplink_classification_bkp)
  #   end
  # end

  describe 'Telemetry Configuration' do
    it 'will be updated and then will rollback' do
      log_int.retrieve!

      sample_count_bkp = log_int['telemetryConfiguration']['sampleCount']
      sample_interval_bkp = log_int['telemetryConfiguration']['sampleInterval']
      sample_count_new = 20
      sample_interval_new = 200

      log_int['telemetryConfiguration']['sampleCount'] = sample_count_new
      log_int['telemetryConfiguration']['sampleInterval'] = sample_interval_new
      log_int.update_telemetry_configuration
      log_int.retrieve!
      expect(log_int['telemetryConfiguration']['sampleCount']).to eq(sample_count_new)
      expect(log_int['telemetryConfiguration']['sampleInterval']).to eq(sample_interval_new)

      log_int['telemetryConfiguration']['sampleCount'] = sample_count_bkp
      log_int['telemetryConfiguration']['sampleInterval'] = sample_interval_bkp
      log_int.update_telemetry_configuration
      log_int.retrieve!

      expect(log_int['telemetryConfiguration']['sampleCount']).to eq(sample_count_bkp)
      expect(log_int['telemetryConfiguration']['sampleInterval']).to eq(sample_interval_bkp)
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::LogicalInterconnect.find_by(@client, {}).map { |item| item[:name] }
      expect(names).to include('Encl2-Simple')
    end

    it 'finds networks by multiple attributes' do
      attrs = { status: 'OK'}
      lis = OneviewSDK::EthernetNetwork.find_by(@client, attrs)
      expect(lis).to_not eq(nil)
    end
  end

end
