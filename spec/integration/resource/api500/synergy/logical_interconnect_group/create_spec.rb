require 'spec_helper'

klass = OneviewSDK::API500::Synergy::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }
  let(:lig_uplink_set_class) { OneviewSDK::API500::Synergy::LIGUplinkSet }
  let(:ethernet_network_class) { OneviewSDK::API500::Synergy::EthernetNetwork }
  let(:fc_network_class) { OneviewSDK::API500::Synergy::FCNetwork }

  include_examples 'LIGSynergyCreateExample', 'integration api500 context'
end
