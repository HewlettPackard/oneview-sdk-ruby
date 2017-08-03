require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::FCoENetwork, integration: true, type: UPDATE do
  include_examples 'FCoENetworkUpdateExample', 'integration api500 context' do
    let(:current_client) { $client_500 }
  end

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API500::C7000::Scope do
    let(:current_client) { $client_500 }
    let(:item) { described_class.get_all(current_client).first }
  end
end
