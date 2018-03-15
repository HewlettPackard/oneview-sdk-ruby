require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::EthernetNetwork, integration: true, type: UPDATE do
  include_examples 'EthernetNetworkUpdateExample', 'integration api600 context' do
    let(:current_client) { $client_600_synergy }
  end
end
