require 'spec_helper'

klass = OneviewSDK::EthernetNetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'EthernetNetworkCreateExample', 'integration context' do
    let(:current_client) { $client }
  end
end
