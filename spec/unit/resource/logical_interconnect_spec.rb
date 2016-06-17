require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnect do
  include_context 'shared context'

  let(:enet_trap) { %w(Other PortStatus PortThresholds) }
  let(:fc_trap) { %w(Other PortStatus) }
  let(:vcm_trap) { %w(Legacy) }
  let(:trap_sev) { %w(Normal Info Warning Critical Major Minor Unknown) }

  let(:fixture_path) { 'spec/support/fixtures/unit/resource/logical_interconnect_default.json' }
  let(:log_int) { OneviewSDK::LogicalInterconnect.from_file(@client, fixture_path) }

  describe '#create' do
    it 'requires the enclosure to have a uri value' do
      expect { log_int.create(1, OneviewSDK::Enclosure.new(@client)) }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'makes a POST call to the base uri' do
      expect(@client).to receive(:rest_post).with(log_int.class::LOCATION_URI, Hash, log_int.api_version)
        .and_return(FakeResponse.new)
      log_int.create(1, OneviewSDK::Enclosure.new(@client, uri: '/rest/fake'))
    end
  end

  describe '#delete' do
    it 'requires the enclosure to have a uri value' do
      expect { log_int.delete(1, OneviewSDK::Enclosure.new(@client)) }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'makes a DELETE call to the base uri' do
      uri = log_int.class::LOCATION_URI + '?location=Enclosure:/rest/fake,Bay:1'
      expect(@client).to receive(:rest_delete).with(uri, {}, log_int.api_version)
        .and_return(FakeResponse.new)
      log_int.delete(1, OneviewSDK::Enclosure.new(@client, uri: '/rest/fake'))
    end
  end

  describe '#update_ethernet_settings' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client).update_ethernet_settings }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'requires the ethernetSettings attribute to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client, uri: '/rest/fake').update_ethernet_settings }.to raise_error(OneviewSDK::IncompleteResource, /Please retrieve/)
    end

    it 'does a PUT to uri/ethernetSettings & updates @data' do
      item = log_int
      expect(@client).to receive(:rest_put).with(item['uri'] + '/ethernetSettings', Hash, item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      item.update_ethernet_settings
      expect(item['key']).to eq('val')
    end
  end

  describe '#update_settings' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client).update_ethernet_settings }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/settings & updates @data' do
      item = log_int
      expect(@client).to receive(:rest_put).with(item['uri'] + '/settings', Hash, item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      item.update_settings
      expect(item['key']).to eq('val')
    end
  end

  describe '#compliance' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client).compliance }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/compliance & updates @data' do
      item = log_int
      expect(@client).to receive(:rest_put).with(item['uri'] + '/compliance', {}, item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      item.compliance
      expect(item['key']).to eq('val')
    end
  end

  describe '#configuration' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client).configuration }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/configuration & updates @data' do
      item = log_int
      expect(@client).to receive(:rest_put).with(item['uri'] + '/configuration', {}, item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      item.configuration
      expect(item['key']).to eq('val')
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

    describe 'will not let weird values in the fields' do
      it 'enetTrapCategories' do
        enet_trap.push('WeirdValue')
        expect { log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev) }.to raise_error(OneviewSDK::InvalidResource, /not one of the allowed values/)
      end

      it 'fcTrapCategories' do
        enet_trap.push('WeirdValue')
        expect { log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev) }.to raise_error(OneviewSDK::InvalidResource, /not one of the allowed values/)
      end

      it 'vcmTrapCategories' do
        enet_trap.push('WeirdValue')
        expect { log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev) }.to raise_error(OneviewSDK::InvalidResource, /not one of the allowed values/)
      end

      it 'trapSeverities' do
        enet_trap.push('WeirdValue')
        expect { log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev) }.to raise_error(OneviewSDK::InvalidResource, /not one of the allowed values/)
      end

      it 'trapFormat' do
        expect { log_int.add_snmp_trap_destination('172.18.6.16', 'NO_VERSION', 'public') }
      end
    end
  end

  describe '#get_firmware' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client).get_firmware }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/firmware & returns the result' do
      expect(@client).to receive(:rest_get).with(log_int['uri'] + '/firmware').and_return(FakeResponse.new(key: 'val'))
      expect(log_int.get_firmware).to eq('key' => 'val')
    end
  end

  describe '#firmware_update' do
    it 'requires the uri to be set' do
      expect { OneviewSDK::LogicalInterconnect.new(@client).firmware_update(:cmd, nil, {}) }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/firmware & returns the result' do
      expect(@client).to receive(:rest_put).with(log_int['uri'] + '/firmware', Hash).and_return(FakeResponse.new(key: 'val'))
      driver = OneviewSDK::FirmwareDriver.new(@client, name: 'FW', uri: '/rest/fake')
      expect(log_int.firmware_update('cmd', driver, {})).to eq('key' => 'val')
    end
  end

  describe 'validations' do
    before :each do
      @item = OneviewSDK::LogicalInterconnect.new(@client)
    end

    it 'only allows certain enet_trap_categories' do
      %w(Other PortStatus PortThresholds).each do |v|
        @item.send(:validate_enet_trap_categories, [v])
      end
      expect { @item.send(:validate_enet_trap_categories, ['fake']) }.to raise_error(OneviewSDK::InvalidResource, /not.*allowed/)
    end

    it 'only allows certain fc_trap_categories' do
      %w(Other PortStatus).each do |v|
        @item.send(:validate_fc_trap_categories, [v])
      end
      expect { @item.send(:validate_fc_trap_categories, ['fake']) }.to raise_error(OneviewSDK::InvalidResource, /not.*allowed/)
    end

    it 'only allows certain vcm_trap_categories' do
      %w(Legacy).each do |v|
        @item.send(:validate_vcm_trap_categories, [v])
      end
      expect { @item.send(:validate_vcm_trap_categories, ['fake']) }.to raise_error(OneviewSDK::InvalidResource, /not.*allowed/)
    end

    it 'only allows certain trap_severities' do
      %w(Critical Info Major Minor Normal Unknown Warning).each do |v|
        @item.send(:validate_trap_severities, [v])
      end
      expect { @item.send(:validate_trap_severities, ['fake']) }.to raise_error(OneviewSDK::InvalidResource, /not.*allowed/)
    end

    it 'only allows certain trap_format' do
      %w(SNMPv1 SNMPv2 SNMPv3).each do |v|
        @item.send(:validate_trap_format, v)
      end
      expect { @item.send(:validate_trap_format, 'fake') }.to raise_error(OneviewSDK::InvalidResource, /not.*allowed/)
    end
  end
end
