require 'spec_helper'

RSpec.describe OneviewSDK::EthernetNetwork, integration: true, type: UPDATE do
  include_examples 'EthernetNetworkUpdateExample', 'integration context' do
    let(:current_client) { $client }
  end
end
