require 'spec_helper'

RSpec.describe OneviewSDK::EthernetNetwork, integration: true do
  include_context 'integration context'

  let(:resource_name) { 'BulkEthernetNetwork' }
  let(:bulk_options) do
    {
      vlanIdRange: '1-5',
      purpose: 'General',
      namePrefix: resource_name,
      smartLink: false,
      privateNetwork: false,
      bandwidth: {
        maximumBandwidth: 10_000,
        typicalBandwidth: 2_000
      },
      type: 'bulk-ethernet-network'
    }
  end

  describe '#create' do
    it 'can create multiple ethernet networks' do
      item = OneviewSDK::BulkEthernetNetwork.new(@client, bulk_options)
      item.create
      networks = OneviewSDK::EthernetNetwork.get_all(@client).select { |e| e['name'].match(/^BulkEthernetNetwork_\d*/) }
      expect(networks.size).to eq(5)
    end
  end
  #
  # describe '#delete' do
  #   it 'deletes the resources' do
  #     networks = OneviewSDK::EthernetNetwork.get_all(@client).select { |e| e['name'].match(/^BulkEthernetNetwork_\d*/) }
  #     networks.each { |n| n.delete }
  #     networks = OneviewSDK::EthernetNetwork.get_all(@client).select { |e| e['name'].match(/^BulkEthernetNetwork_\d*/) }
  #     expect(networks.size).to eq(0)
  #   end
  # end

end
