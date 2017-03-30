require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::EthernetNetwork, integration: true, type: UPDATE do
  include_examples 'EthernetNetworkUpdateExample', 'integration api300 context' do
    let(:current_client) { $client_300_synergy }
  end
end
