require 'spec_helper'

klass = OneviewSDK::API500::C7000::FCNetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'FCNetworkCreateExample', 'integration api500 context' do
    let(:current_client) { $client_500 }
  end
end
