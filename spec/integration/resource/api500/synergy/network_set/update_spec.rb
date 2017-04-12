require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::NetworkSet, integration: true, type: UPDATE, sequence: 2 do
  let(:current_client) { $client_500_synergy }
  let(:ethernet_class) { OneviewSDK::API500::Synergy::EthernetNetwork }

  include_examples 'NetworkSetUpdateExample', 'integration api500 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API500::Synergy::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
