require 'spec_helper'

klass = OneviewSDK::API300::C7000::FCoENetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'FCoENetworkCreateExample', 'integration api300 context' do
    let(:current_client) { $client_300 }
  end
end
