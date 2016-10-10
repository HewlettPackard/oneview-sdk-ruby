require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::NetworkSet
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#delete' do
    it 'network set 1' do
      item = OneviewSDK::API300::Thunderbird::NetworkSet.new($client_300, name: NETWORK_SET1_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end

    it 'network set 2' do
      item = OneviewSDK::API300::Thunderbird::NetworkSet.new($client_300, name: NETWORK_SET2_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end

    it 'network set 3' do
      item = OneviewSDK::API300::Thunderbird::NetworkSet.new($client_300, name: NETWORK_SET3_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end

    it 'network set 4' do
      item = OneviewSDK::API300::Thunderbird::NetworkSet.new($client_300, name: NETWORK_SET4_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end

  end
end
