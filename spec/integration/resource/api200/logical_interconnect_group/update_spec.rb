require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true, type: UPDATE do
  let(:current_client) { $client }
  let(:lig_uplink_set_class) { OneviewSDK::LIGUplinkSet }
  let(:ethernet_network_class) { OneviewSDK::EthernetNetwork }

  include_examples 'LIGC7000UpdateExample', 'integration context'
end
