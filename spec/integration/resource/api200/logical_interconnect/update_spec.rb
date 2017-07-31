require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnect, integration: true, type: UPDATE do
  let(:current_client) { $client }
  let(:enclosure_class) { OneviewSDK::Enclosure }
  let(:ethernet_class) { OneviewSDK::EthernetNetwork }
  let(:interconnect_class) { OneviewSDK::Interconnect }
  let(:log_int_name) { LOG_INT_NAME }
  let(:encl_name) { ENCL_NAME }

  include_examples 'LogicalInterconnectUpdateExample', 'integration context'
end
