require 'spec_helper'

RSpec.describe OneviewSDK::NetworkSet, integration: true, type: UPDATE, sequence: 2 do
  let(:current_client) { $client }
  let(:ethernet_class) { OneviewSDK::EthernetNetwork }

  include_examples 'NetworkSetUpdateExample', 'integration context'
end
