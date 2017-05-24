require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::LogicalInterconnect, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  let(:enclosure_class) { OneviewSDK::API300::Synergy::Enclosure }
  let(:ethernet_class) { OneviewSDK::API300::Synergy::EthernetNetwork }
  let(:interconnect_class) { OneviewSDK::API300::Synergy::Interconnect }
  let(:log_int_name) { LOG_INT2_NAME }
  let(:encl_name) { ENCL2_NAME }

  include_examples 'LogicalInterconnectUpdateExample', 'integration api300 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::Synergy::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
