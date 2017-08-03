require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::NetworkSet, integration: true, type: UPDATE, sequence: 2 do
  let(:current_client) { $client_300_synergy }
  let(:ethernet_class) { OneviewSDK::API300::Synergy::EthernetNetwork }

  include_examples 'NetworkSetUpdateExample', 'integration api300 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::Synergy::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
