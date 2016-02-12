require 'spec_helper'

RSpec.describe OneviewSDK::EnclosureGroup do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 1.2' do
      it 'sets the defaults correctly' do
        item = OneviewSDK::EnclosureGroup.new(@client_120)
        expect(item[:type]).to eq('EnclosureGroupV2')
      end
    end

    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        item = OneviewSDK::EnclosureGroup.new(@client)
        expect(item[:type]).to eq('EnclosureGroupV200')
      end
    end
  end

  describe 'validations' do
    it 'only allows an interconnectBayMappingCount between 1 and 8' do
      expect { OneviewSDK::EnclosureGroup.new(@client, interconnectBayMappingCount: 0) }.to raise_error(/out of range/)
      expect { OneviewSDK::EnclosureGroup.new(@client, interconnectBayMappingCount: 1) }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, interconnectBayMappingCount: 8) }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, interconnectBayMappingCount: 9) }.to raise_error(/out of range/)
    end

    it 'only allows certain ipAddressingMode values' do
      expect { OneviewSDK::EnclosureGroup.new(@client, ipAddressingMode: 'DHCP') }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, ipAddressingMode: 'External') }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, ipAddressingMode: 'IpPool') }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, ipAddressingMode: '') }.to raise_error(/Invalid ip AddressingMode/)
      expect { OneviewSDK::EnclosureGroup.new(@client, ipAddressingMode: 'invalid') }.to raise_error(/Invalid ip AddressingMode/)
    end

    it 'only allows an portMappingCount between 0 and 8' do
      expect { OneviewSDK::EnclosureGroup.new(@client, portMappingCount: -1) }.to raise_error(/out of range/)
      expect { OneviewSDK::EnclosureGroup.new(@client, portMappingCount: 0) }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, portMappingCount: 8) }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, portMappingCount: 9) }.to raise_error(/out of range/)
    end

    it 'only allows certain powerMode values' do
      expect { OneviewSDK::EnclosureGroup.new(@client, powerMode: 'RedundantPowerFeed') }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, powerMode: 'RedundantPowerSupply') }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, powerMode: '') }.to raise_error(/Invalid powerMode/)
      expect { OneviewSDK::EnclosureGroup.new(@client, powerMode: 'invalid') }.to raise_error(/Invalid powerMode/)
    end

    it 'only allows certain stackingMode values' do
      expect { OneviewSDK::EnclosureGroup.new(@client, stackingMode: 'Enclosure') }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, stackingMode: 'MultiEnclosure') }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, stackingMode: 'None') }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, stackingMode: 'SwitchPairs') }.to_not raise_error
      expect { OneviewSDK::EnclosureGroup.new(@client, stackingMode: '') }.to raise_error(/Invalid stackingMode/)
      expect { OneviewSDK::EnclosureGroup.new(@client, stackingMode: 'invalid') }.to raise_error(/Invalid stackingMode/)
    end
  end

  describe '#script' do
    it 'requires a uri' do
      expect { OneviewSDK::EnclosureGroup.new(@client).script }.to raise_error(/Please set uri/)
    end

    it 'gets uri/script' do
      item = OneviewSDK::EnclosureGroup.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with("/rest/fake/script", item.api_version).and_return(FakeResponse.new('Blah'))
      expect(@client.logger).to receive(:warn).with(/Failed to parse JSON response/).and_return(true)
      expect(item.script).to eq('Blah')
    end
  end

  describe '#set_script' do
    it 'requires a uri' do
      expect { OneviewSDK::EnclosureGroup.new(@client).set_script('Blah') }.to raise_error(/Please set uri/)
    end

    it 'does a PUT to uri/script' do
      item = OneviewSDK::EnclosureGroup.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_put).with('/rest/fake/script', { 'body' => 'Blah'}, item.api_version).and_return(FakeResponse.new('Blah'))
      expect(@client.logger).to receive(:warn).with(/Failed to parse JSON response/).and_return(true)
      expect(item.set_script('Blah')).to eq(true)
    end
  end
end
