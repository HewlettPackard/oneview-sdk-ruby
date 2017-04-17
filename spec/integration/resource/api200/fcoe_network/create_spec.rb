require 'spec_helper'

klass = OneviewSDK::FCoENetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'FCoENetworkCreateExample', 'integration context' do
    let(:current_client) { $client }
  end
end
