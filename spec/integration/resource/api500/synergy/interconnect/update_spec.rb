require 'spec_helper'

klass = OneviewSDK::API500::Synergy::Interconnect
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  let(:interconnect_name) { INTERCONNECT_3_NAME }
  let(:ethernet_class) { OneviewSDK::API500::Synergy::EthernetNetwork }

  include_examples 'InterconnectUpdateExample', 'integration api500 context'
end
