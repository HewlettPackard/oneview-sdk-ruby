require 'spec_helper'

klass = OneviewSDK::API500::Synergy::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  let(:ethernet_network_class) { OneviewSDK::API500::Synergy::EthernetNetwork }
  let(:item) { described_class.find_by(current_client, name: LOG_INT_GROUP_NAME).first }

  it_behaves_like 'LIGSynergyUpdateExample', 'integration api500 context'
  it_behaves_like 'ScopeHelperMethodsExample', OneviewSDK::API500::Synergy::Scope
end
