require 'spec_helper'

RSpec.describe OneviewSDK::NetworkSet, integration: true, type: DELETE, sequence: 11 do
  include_context 'integration context'

  describe '#delete' do
    it 'network set 1' do
      item = OneviewSDK::NetworkSet.new($client, name: NETWORK_SET1_NAME)
      item.retrieve!
      item.delete
    end

    it 'network set 2' do
      item = OneviewSDK::NetworkSet.new($client, name: NETWORK_SET2_NAME)
      item.retrieve!
      item.delete
    end

    it 'network set 3' do
      item = OneviewSDK::NetworkSet.new($client, name: NETWORK_SET3_NAME)
      item.retrieve!
      item.delete
    end

    it 'network set 4' do
      item = OneviewSDK::NetworkSet.new($client, name: NETWORK_SET4_NAME)
      item.retrieve!
      item.delete
    end

  end
end
