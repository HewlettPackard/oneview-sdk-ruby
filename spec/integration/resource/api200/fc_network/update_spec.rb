require 'spec_helper'

RSpec.describe OneviewSDK::FCNetwork, integration: true, type: UPDATE do
  include_examples 'FCNetworkUpdateExample', 'integration context' do
    let(:current_client) { $client }
  end
end
