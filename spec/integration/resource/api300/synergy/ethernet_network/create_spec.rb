require 'spec_helper'

klass = OneviewSDK::API300::Synergy::EthernetNetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'EthernetNetworkCreateExample', 'integration api300 context' do
    let(:current_client) { $client_300_synergy }
  end
end
