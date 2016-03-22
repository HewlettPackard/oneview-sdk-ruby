require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true, type: DELETE, sequence: 11 do
  include_context 'integration context'

  let(:lig_default_options) do
    {
      'name' => LOG_INT_GROUP_NAME,
      'enclosureType' => 'C7000',
      'type' => 'logical-interconnect-groupV3'
    }
  end
  let(:lig) { OneviewSDK::LogicalInterconnectGroup.new($client, lig_default_options) }
  let(:interconnect_type) { 'HP VC FlexFabric 10Gb/24-Port Module' }

  describe '#delete' do
    it 'deletes the lig' do
      lig.retrieve!
      lig.delete
    end
  end
end
