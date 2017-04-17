require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::NetworkSet, integration: true, type: UPDATE, sequence: 2 do
  let(:current_client) { $client_300 }
  let(:ethernet_class) { OneviewSDK::API300::C7000::EthernetNetwork }

  include_examples 'NetworkSetUpdateExample', 'integration api300 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
