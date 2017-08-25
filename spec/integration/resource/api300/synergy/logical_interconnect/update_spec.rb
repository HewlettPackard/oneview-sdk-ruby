require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::LogicalInterconnect, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  let(:enclosure_class) { OneviewSDK::API300::Synergy::Enclosure }
  let(:ethernet_class) { OneviewSDK::API300::Synergy::EthernetNetwork }
  let(:interconnect_class) { OneviewSDK::API300::Synergy::Interconnect }
  let(:log_int_name) { LOG_INT2_NAME }
  let(:encl_name) { ENCL2_NAME }

  it_behaves_like 'LogicalInterconnectUpdateExample', 'integration api300 context'

  it_behaves_like 'ScopeHelperMethodsExample', OneviewSDK::API300::Synergy::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end

  # should create the uplinkSet again, because the compliance method removed it, but it one is used in uplinkSet update tests
  it_behaves_like 'UplinkSetCreateExample', 'integration context' do
    let(:li_name) { LOG_INT2_NAME }
    let(:described_class) { OneviewSDK::API300::Synergy::UplinkSet }
  end
end
