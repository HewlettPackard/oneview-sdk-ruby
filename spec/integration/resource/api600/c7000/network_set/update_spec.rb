require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::NetworkSet, integration: true, type: UPDATE, sequence: 2 do
  let(:current_client) { $client_600 }
  let(:ethernet_class) { OneviewSDK::API600::C7000::EthernetNetwork }

  include_examples 'NetworkSetUpdateExample', 'integration api600 context'
end
