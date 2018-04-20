require 'spec_helper'

RSpec.describe OneviewSDK::API800::C7000::HypervisorClusterProfile, integration: true, type: UPDATE do
  include_examples 'HypervisorClusterProfileUpdateExample', 'integration api800 context' do
    let(:current_client) { $client_800 }
  end
end
