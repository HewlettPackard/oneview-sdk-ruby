require 'spec_helper'

klass = OneviewSDK::EthernetNetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::EthernetNetwork.new($client, name: ETH_NET_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end

    it 'deletes bulk created networks' do
      range = BULK_ETH_NET_RANGE.split('-').map(&:to_i)
      network_names = []
      range[0].upto(range[1]) { |i| network_names << "#{BULK_ETH_NET_PREFIX}_#{i}" }
      network_names.each do |name|
        network = OneviewSDK::EthernetNetwork.new($client, name: name)
        network.retrieve!
        expect { network.delete }.not_to raise_error
      end
    end
  end
end
