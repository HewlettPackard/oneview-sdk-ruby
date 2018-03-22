require 'spec_helper'

klass = OneviewSDK::API600::C7000::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  let(:lig_uplink_set_class) { OneviewSDK::API600::C7000::LIGUplinkSet }
  let(:ethernet_network_class) { OneviewSDK::API600::C7000::EthernetNetwork }
  let(:item) { described_class.find_by(current_client, name: LOG_INT_GROUP3_NAME).first }

  it_behaves_like 'LIGC7000UpdateExample', 'integration api600 context'
  it_behaves_like 'ScopeHelperMethodsExample', OneviewSDK::API600::C7000::Scope
end
