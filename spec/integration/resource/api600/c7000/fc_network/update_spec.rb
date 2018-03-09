require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::FCNetwork, integration: true, type: UPDATE do
  include_examples 'FCNetworkUpdateExample', 'integration api600 context' do
    let(:current_client) { $client_600 }
  end
end
