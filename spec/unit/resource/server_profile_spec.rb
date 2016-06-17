require 'spec_helper'

RSpec.describe OneviewSDK::ServerProfile do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the type correctly' do
      profile = OneviewSDK::ServerProfile.new(@client)
      expect(profile[:type]).to eq('ServerProfileV5')
    end
  end

  describe '#available_hardware' do
    it 'requires the serverHardwareTypeUri value to be set' do
      expect { OneviewSDK::ServerProfile.new(@client).available_hardware }.to raise_error(OneviewSDK::IncompleteResource, /Must set.*serverHardwareTypeUri/)
    end

    it 'requires the enclosureGroupUri value to be set' do
      expect { OneviewSDK::ServerProfile.new(@client, serverHardwareTypeUri: '/rest/fake').available_hardware }
        .to raise_error(OneviewSDK::IncompleteResource, /Must set.*enclosureGroupUri/)
    end

    it 'calls #find_by with the serverHardwareTypeUri and enclosureGroupUri' do
      item = OneviewSDK::ServerProfile.new(@client, serverHardwareTypeUri: '/rest/fake', enclosureGroupUri: '/rest/fake2')
      params = { state: 'NoProfileApplied', serverHardwareTypeUri: item['serverHardwareTypeUri'], serverGroupUri: item['enclosureGroupUri'] }
      expect(OneviewSDK::ServerHardware).to receive(:find_by).with(@client, params).and_return([])
      expect(item.available_hardware).to eq([])
    end
  end

  describe 'validations' do
    it 'validates serverProfileTemplateUri' do
      expect { described_class.new(@client_120, serverProfileTemplateUri: '/rest/fake') }.to raise_error(OneviewSDK::UnsupportedVersion, /api version >= 200/)
      described_class.new(@client, serverProfileTemplateUri: '/rest/fake') # Should work
    end

    it 'validates templateCompliance' do
      expect { described_class.new(@client_120, templateCompliance: true) }.to raise_error(OneviewSDK::UnsupportedVersion, /api version >= 200/)
      described_class.new(@client, templateCompliance: true) # Should work
    end
  end

end
