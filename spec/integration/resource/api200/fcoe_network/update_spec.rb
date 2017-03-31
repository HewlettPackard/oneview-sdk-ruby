require 'spec_helper'

RSpec.describe OneviewSDK::FCoENetwork, integration: true, type: UPDATE do
  include_examples 'FCoENetworkUpdateExample', 'integration context' do
    let(:current_client) { $client }
  end
end
