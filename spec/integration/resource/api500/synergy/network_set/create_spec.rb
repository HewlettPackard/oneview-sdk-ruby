require 'spec_helper'

klass = OneviewSDK::API500::Synergy::NetworkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }
  let(:ethernet_class) { OneviewSDK::API500::Synergy::EthernetNetwork }

  include_examples 'NetworkSetCreateExample', 'integration api500 context'
end
