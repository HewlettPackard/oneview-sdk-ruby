require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::LogicalInterconnect, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  let(:enclosure_class) { OneviewSDK::API600::C7000::Enclosure }
  let(:ethernet_class) { OneviewSDK::API600::C7000::EthernetNetwork }
  let(:interconnect_class) { OneviewSDK::API600::C7000::Interconnect }
  let(:log_int_name) { LOG_INT_NAME }
  let(:encl_name) { ENCL_NAME }

  # should create the uplinkSet again, because the compliance method removed it, but it one is used in uplinkSet update tests
  it_behaves_like 'UplinkSetCreateExample', 'integration context' do
    let(:li_name) { LOG_INT_NAME }
    let(:described_class) { OneviewSDK::API600::C7000::UplinkSet }
  end
end
