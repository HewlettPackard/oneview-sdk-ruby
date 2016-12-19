require 'spec_helper'

klass = OneviewSDK::ConnectionTemplate
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration context'

  describe '#get_default' do
    it 'builds connection template' do
      item = klass.get_default($client)
      expect(item).to be_a klass
    end
  end

  describe '#update' do
    it 'change bandwidth' do
      item = klass.find_by($client, {}).first
      old_maximum = item['bandwidth']['maximumBandwidth']
      old_typical = item['bandwidth']['typicalBandwidth']
      item['bandwidth']['maximumBandwidth'] = old_maximum - 100
      item['bandwidth']['typicalBandwidth'] = old_typical - 100
      expect { item.update }.not_to raise_error
      expect(item['bandwidth']['maximumBandwidth']).to eq(old_maximum - 100)
      expect(item['bandwidth']['typicalBandwidth']).to eq(old_typical - 100)
      item.retrieve!
      item['bandwidth']['maximumBandwidth'] = old_maximum
      item['bandwidth']['typicalBandwidth'] = old_typical
      expect { item.update }.not_to raise_error
      expect(item['bandwidth']['maximumBandwidth']).to eq(old_maximum)
      expect(item['bandwidth']['typicalBandwidth']).to eq(old_typical)
    end
  end
end
