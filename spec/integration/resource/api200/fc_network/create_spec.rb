require 'spec_helper'

klass = OneviewSDK::FCNetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'FCNetworkCreateExample', 'integration context' do
    let(:current_client) { $client }
  end
end
