require 'spec_helper'

klass = OneviewSDK::API600::C7000::FCNetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'FCNetworkCreateExample', 'integration api600 context' do
    let(:current_client) { $client_600 }
  end
end
