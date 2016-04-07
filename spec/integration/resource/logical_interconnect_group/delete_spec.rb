require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true, type: DELETE, sequence: 11 do
  include_context 'integration context'

  let(:item) do
    lig = OneviewSDK::LogicalInterconnectGroup.new($client, name: LOG_INT_GROUP_NAME)
    lig.retrieve!
    lig
  end

  let(:item_2) do
    lig = OneviewSDK::LogicalInterconnectGroup.new($client, name: LOG_INT_GROUP2_NAME)
    lig.retrieve!
    lig
  end

  describe '#delete' do
    it 'removes all the Logical Interconnect groups' do
      expect { item.delete }.to_not raise_error
      expect { item_2.delete }.to_not raise_error
    end
  end
end
