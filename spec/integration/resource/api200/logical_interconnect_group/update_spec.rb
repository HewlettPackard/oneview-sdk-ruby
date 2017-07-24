require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true, type: UPDATE do
  let(:current_client) { $client }
  let(:lig_uplink_set_class) { OneviewSDK::LIGUplinkSet }
  let(:ethernet_network_class) { OneviewSDK::EthernetNetwork }
  let(:item) { described_class.find_by(current_client, name: LOG_INT_GROUP3_NAME).first }

  include_examples 'LIGC7000UpdateExample', 'integration context'
end
