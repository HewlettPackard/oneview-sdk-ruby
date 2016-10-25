require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalEnclosure
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:value) do
    {
      firmwareUpdateOn: 'SharedInfrastructureOnly',
      forceInstallFirmware: false,
      updateFirmwareOnUnmanagedInterconnect: true
    }
  end

  describe '#patch' do
    it 'Update a given logical enclosure' do
      item = klass.find_by($client_300, name: LOG_ENCL1_NAME).first
      response = nil
      expect { response = item.patch(value) }.to_not raise_error
      expect(response['uri']).to eq(item['uri'])
      expect(response['name']).to eq(item['name'])
    end
  end
end
