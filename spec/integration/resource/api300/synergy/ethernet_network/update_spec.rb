require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::EthernetNetwork, integration: true, type: UPDATE do
  include_examples 'EthernetNetworkUpdateExample', 'integration api300 context' do
    let(:current_client) { $client_300_synergy }
  end

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::Synergy::Scope do
    let(:current_client) { $client_300_synergy }
    let(:item) { described_class.get_all(current_client).first }
  end
end
