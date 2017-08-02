require 'spec_helper'

klass = OneviewSDK::API300::Synergy::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300_synergy }
  let(:lig_uplink_set_class) { OneviewSDK::API300::Synergy::LIGUplinkSet }
  let(:ethernet_network_class) { OneviewSDK::API300::Synergy::EthernetNetwork }
  let(:fc_network_class) { OneviewSDK::API300::Synergy::FCNetwork }

  include_examples 'LIGSynergyCreateExample', 'integration api300 context'
end
