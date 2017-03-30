require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::EthernetNetwork, integration: true, type: UPDATE do
  include_examples 'EthernetNetworkUpdateExample', 'integration api500 context' do
    let(:current_client) { $client_500_synergy }
  end
end
