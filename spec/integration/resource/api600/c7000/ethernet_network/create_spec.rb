require 'spec_helper'

klass = OneviewSDK::API600::C7000::EthernetNetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'EthernetNetworkCreateExample', 'integration api600 context' do
    let(:current_client) { $client_600 }
  end
end
