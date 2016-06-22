require 'spec_helper'

RSpec.describe OneviewSDK::LogicalDownlink, integration: true, type: CREATE, sequence: 1 do
  include_context 'integration context'

  describe '#get_without_ethernet' do
    it 'can get and build logical downlinks without ethernet networks' do
      item = OneviewSDK::LogicalDownlink.find_by($client, {}).first
      logical_downlink_without_ethernet = item.get_without_ethernet
      expect(logical_downlink_without_ethernet.class).to eq(described_class)
    end
  end

  describe '#self.get_without_ethernet' do
    it 'can get and build logical downlinks for a logical downlink without ethernet networks' do
      logical_downlinks = OneviewSDK::LogicalDownlink.get_without_ethernet($client)
      expect(logical_downlinks.first.class).to eq(described_class)
    end
  end
end
