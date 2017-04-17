require 'spec_helper'

klass = OneviewSDK::API300::Synergy::NetworkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300_synergy }
  let(:ethernet_class) { OneviewSDK::API300::Synergy::EthernetNetwork }

  include_examples 'NetworkSetCreateExample', 'integration api300 context'
end
