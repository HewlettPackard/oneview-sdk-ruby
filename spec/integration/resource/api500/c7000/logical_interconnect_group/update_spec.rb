require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  let(:lig_uplink_set_class) { OneviewSDK::API500::C7000::LIGUplinkSet }
  let(:ethernet_network_class) { OneviewSDK::API500::C7000::EthernetNetwork }

  it_behaves_like 'LIGC7000UpdateExample', 'integration api500 context'

  it_behaves_like 'ScopeHelperMethodsExample', OneviewSDK::API500::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
