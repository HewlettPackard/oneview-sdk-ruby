require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::EthernetNetwork
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#delete' do
    it 'deletes the resource' do
      item = OneviewSDK::API300::Thunderbird::EthernetNetwork.new($client_300, name: ETH_NET_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end

    it 'deletes bulk created networks' do
      range = BULK_ETH_NET_RANGE.split('-').map(&:to_i)
      network_names = []
      range[0].upto(range[1]) { |i| network_names << "#{BULK_ETH_NET_PREFIX}_#{i}" }
      network_names.each do |name|
        network = OneviewSDK::API300::Thunderbird::EthernetNetwork.new($client_300, name: name)
        network.retrieve!
        expect { network.delete }.not_to raise_error
      end
    end
  end
end
