require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnect, integration: true, type: UPDATE do
  let(:current_client) { $client }
  let(:enclosure_class) { OneviewSDK::Enclosure }
  let(:ethernet_class) { OneviewSDK::EthernetNetwork }
  let(:interconnect_class) { OneviewSDK::Interconnect }
  let(:log_int_name) { LOG_INT_NAME }
  let(:encl_name) { ENCL_NAME }

  it_behaves_like 'LogicalInterconnectUpdateExample', 'integration context'

  # should create the uplinkSet again, because the compliance method removed it, but it one is used in uplinkSet update tests
  it_behaves_like 'UplinkSetCreateExample', 'integration context' do
    let(:li_name) { LOG_INT_NAME }
    let(:described_class) { OneviewSDK::UplinkSet }
  end
end
