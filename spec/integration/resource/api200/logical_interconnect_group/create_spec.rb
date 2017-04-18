require 'spec_helper'

klass = OneviewSDK::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:lig_uplink_set_class) { OneviewSDK::LIGUplinkSet }
  let(:ethernet_network_class) { OneviewSDK::EthernetNetwork }
  let(:fc_network_class) { OneviewSDK::FCNetwork }
  let(:default_settings_type) { 'InterconnectSettingsV3' }

  include_examples 'LIGC7000CreateExample', 'integration context'
end
