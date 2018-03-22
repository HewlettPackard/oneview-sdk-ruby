require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::FCoENetwork, integration: true, type: UPDATE do
  include_examples 'FCoENetworkUpdateExample', 'integration api600 context' do
    let(:current_client) { $client_600 }
  end
end
