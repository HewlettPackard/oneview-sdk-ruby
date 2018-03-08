require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::FCNetwork, integration: true, type: UPDATE do
  include_examples 'FCNetworkUpdateExample', 'integration api600 context' do
    let(:current_client) { $client_600_synergy }
  end

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API600::Synergy::Scope do
    let(:current_client) { $client_600_synergy }
    let(:item) { described_class.get_all(current_client).first }
  end
end
