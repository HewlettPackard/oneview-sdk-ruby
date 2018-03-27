require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::NetworkSet, integration: true, type: UPDATE, sequence: 2 do
  let(:current_client) { $client_600_synergy }
  let(:ethernet_class) { OneviewSDK::API600::Synergy::EthernetNetwork }

  include_examples 'NetworkSetUpdateExample', 'integration api600 context'
end
