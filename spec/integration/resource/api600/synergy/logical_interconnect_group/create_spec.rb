require 'spec_helper'

klass = OneviewSDK::API600::Synergy::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600_synergy }
  let(:lig_uplink_set_class) { OneviewSDK::API600::Synergy::LIGUplinkSet }
  let(:ethernet_network_class) { OneviewSDK::API600::Synergy::EthernetNetwork }
  let(:fc_network_class) { OneviewSDK::API600::Synergy::FCNetwork }

  include_examples 'LIGSynergyCreateExample', 'integration api600 context'
end
