require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500 }
  let(:lig_uplink_set_class) { OneviewSDK::API500::C7000::LIGUplinkSet }
  let(:ethernet_network_class) { OneviewSDK::API500::C7000::EthernetNetwork }
  let(:fc_network_class) { OneviewSDK::API500::C7000::FCNetwork }
  let(:default_settings_type) { 'InterconnectSettingsV201' }

  include_examples 'LIGC7000CreateExample', 'integration api500 context'
end
