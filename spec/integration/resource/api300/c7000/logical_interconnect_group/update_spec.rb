require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  let(:lig_uplink_set_class) { OneviewSDK::API300::C7000::LIGUplinkSet }
  let(:ethernet_network_class) { OneviewSDK::API300::C7000::EthernetNetwork }

  include_examples 'LIGC7000UpdateExample', 'integration api300 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
