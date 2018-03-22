require 'spec_helper'

klass = OneviewSDK::API600::Synergy::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600_synergy }
  let(:ethernet_network_class) { OneviewSDK::API600::Synergy::EthernetNetwork }
  let(:item) { described_class.find_by(current_client, name: LOG_INT_GROUP_NAME).first }

  it_behaves_like 'LIGSynergyUpdateExample', 'integration api600 context'
  it_behaves_like 'ScopeHelperMethodsExample', OneviewSDK::API600::Synergy::Scope
end
