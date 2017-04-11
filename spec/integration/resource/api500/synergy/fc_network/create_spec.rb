require 'spec_helper'

klass = OneviewSDK::API500::Synergy::FCNetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'FCNetworkCreateExample', 'integration api500 context' do
    let(:current_client) { $client_500_synergy }
  end
end
