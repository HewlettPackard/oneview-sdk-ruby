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
      OneviewSDK::EnclosureGroup::VALID_INTERCONNECT_BAY_MAPPING_COUNTS.each do |i|
        expect { OneviewSDK::EnclosureGroup.new(@client, interconnectBayMappingCount: i) }.to_not raise_error
      end
      expect { OneviewSDK::EnclosureGroup.new(@client, interconnectBayMappingCount: 0) }.to raise_error(/out of range/)
      expect { OneviewSDK::EnclosureGroup.new(@client, interconnectBayMappingCount: 9) }.to raise_error(/out of range/)
    end

    it 'only allows certain ipAddressingMode values' do
      OneviewSDK::EnclosureGroup::VALID_IP_ADDRESSING_MODES.each do |i|
        synergy_with_valid_types = {
          enclosureTypeUri: 'rest/enclosure-types/synergy',
          ipAddressingMode: i
        }
        expect { OneviewSDK::EnclosureGroup.new(@client, synergy_with_valid_types) }.to_not raise_error
      end
      synergy_with_invalid_type = {
        enclosureTypeUri: 'rest/enclosure-types/synergy',
        ipAddressingMode: 'invalid'
      }
      expect { OneviewSDK::EnclosureGroup.new(@client, synergy_with_invalid_type) }.to raise_error(/Invalid ip AddressingMode/)

      # The invalid param should be ignored if the Enclosure Type is not specified or is C7000
      synergy_with_null_addressing_mode = {
        enclosureTypeUri: 'rest/enclosure-types/synergy',
        ipAddressingMode: nil
      }
      expect { OneviewSDK::EnclosureGroup.new(@client, synergy_with_null_addressing_mode) }.to raise_error(/Invalid ip AddressingMode/)
      with_nothing_specified = {
        enclosureTypeUri: nil,
        ipAddressingMode: nil
      }
      expect { OneviewSDK::EnclosureGroup.new(@client, with_nothing_specified) }.to_not raise_error
      without_enclosure_type_specified = {
        enclosureTypeUri: nil,
        ipAddressingMode: 'invalid'
      }
      expect { OneviewSDK::EnclosureGroup.new(@client, without_enclosure_type_specified) }.to_not raise_error
      with_enclosure_c7000 = {
        enclosureTypeUri: nil,
        ipAddressingMode: 'invalid'
      }
      expect { OneviewSDK::EnclosureGroup.new(@client, with_enclosure_c7000) }.to_not raise_error
    end

    it 'only allows an portMappingCount between 0 and 8' do
      OneviewSDK::EnclosureGroup::VALID_PORT_MAPPING_COUNTS.each do |i|
        expect { OneviewSDK::EnclosureGroup.new(@client, portMappingCount: i) }.to_not raise_error
      end
      expect { OneviewSDK::EnclosureGroup.new(@client, portMappingCount: -1) }.to raise_error(/out of range/)
      expect { OneviewSDK::EnclosureGroup.new(@client, portMappingCount: 9) }.to raise_error(/out of range/)
    end

    it 'only allows certain powerMode values' do
      OneviewSDK::EnclosureGroup::VALID_POWER_MODES.each do |i|
        expect { OneviewSDK::EnclosureGroup.new(@client, powerMode: i) }.to_not raise_error
      end
      expect { OneviewSDK::EnclosureGroup.new(@client, powerMode: '') }.to raise_error(/Invalid powerMode/)
      expect { OneviewSDK::EnclosureGroup.new(@client, powerMode: 'invalid') }.to raise_error(/Invalid powerMode/)
    end

    it 'only allows certain stackingMode values' do
      OneviewSDK::EnclosureGroup::VALID_STACKING_MODES.each do |i|
        expect { OneviewSDK::EnclosureGroup.new(@client, stackingMode: i) }.to_not raise_error
      end
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
      expect(@client).to receive(:rest_get).with('/rest/fake/script', item.api_version).and_return(FakeResponse.new('Blah'))
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
      expect(@client).to receive(:rest_put).with('/rest/fake/script', { 'body' => 'Blah' }, item.api_version).and_return(FakeResponse.new('Blah'))
      expect(@client.logger).to receive(:warn).with(/Failed to parse JSON response/).and_return(true)
      expect(item.set_script('Blah')).to eq(true)
    end
  end
end
