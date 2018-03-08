require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::FCNetwork, integration: true, type: UPDATE do
  include_examples 'FCNetworkUpdateExample', 'integration api600 context' do
    let(:current_client) { $client_600 }
  end

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API600::C7000::Scope do
    let(:current_client) { $client_600 }
    let(:item) { described_class.get_all(current_client).first }
  end
end
