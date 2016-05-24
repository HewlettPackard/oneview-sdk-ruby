require 'spec_helper'

RSpec.describe OneviewSDK::ConnectionTemplate, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#get_default' do
    it 'builds connection template' do
      item = OneviewSDK::ConnectionTemplate.get_default($client)
      expect(item).to be_a OneviewSDK::ConnectionTemplate
    end
  end

  describe '#update' do
    it 'change bandwidth' do
      item = OneviewSDK::ConnectionTemplate.find_by($client, {}).first
      old_maximum = item['bandwidth']['maximumBandwidth']
      old_typical = item['bandwidth']['typicalBandwidth']
      item['bandwidth']['maximumBandwidth'] = old_maximum + 1000
      item['bandwidth']['typicalBandwidth'] = old_typical + 500
      item.update
      expect(item['bandwidth']['maximumBandwidth']).to eq(old_maximum + 1000)
      expect(item['bandwidth']['typicalBandwidth']).to eq(old_typical + 500)
    end
  end
end
