require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::LogicalInterconnect, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  let(:enclosure_class) { OneviewSDK::API300::C7000::Enclosure }
  let(:ethernet_class) { OneviewSDK::API300::C7000::EthernetNetwork }
  let(:interconnect_class) { OneviewSDK::API300::C7000::Interconnect }
  let(:log_int_name) { LOG_INT_NAME }
  let(:encl_name) { ENCL_NAME }

  include_examples 'LogicalInterconnectUpdateExample', 'integration api300 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
