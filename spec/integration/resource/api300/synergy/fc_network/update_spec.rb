require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::FCNetwork, integration: true, type: UPDATE do
  include_examples 'FCNetworkUpdateExample', 'integration api300 context' do
    let(:current_client) { $client_300_synergy }
  end

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::Synergy::Scope do
    let(:current_client) { $client_300_synergy }
    let(:item) { described_class.get_all(current_client).first }
  end
end
