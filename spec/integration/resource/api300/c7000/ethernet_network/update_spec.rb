require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::EthernetNetwork, integration: true, type: UPDATE do
  include_examples 'EthernetNetworkUpdateExample', 'integration api300 context' do
    let(:current_client) { $client_300 }
  end
end
