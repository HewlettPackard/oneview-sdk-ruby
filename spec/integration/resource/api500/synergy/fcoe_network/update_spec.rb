require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::FCoENetwork, integration: true, type: UPDATE do
  include_examples 'FCoENetworkUpdateExample', 'integration api500 context' do
    let(:current_client) { $client_500_synergy }
  end

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API500::Synergy::Scope do
    let(:current_client) { $client_500_synergy }
    let(:item) { described_class.get_all(current_client).first }
  end
end
