require 'spec_helper'

klass = OneviewSDK::API300::Synergy::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  let(:ethernet_network_class) { OneviewSDK::API300::Synergy::EthernetNetwork }

  include_examples 'LIGSynergyUpdateExample', 'integration api300 context'

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::Synergy::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
