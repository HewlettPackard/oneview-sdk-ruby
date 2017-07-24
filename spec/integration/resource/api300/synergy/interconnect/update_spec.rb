require 'spec_helper'

klass = OneviewSDK::API300::Synergy::Interconnect
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  let(:interconnect_name) { INTERCONNECT_4_NAME }
  let(:ethernet_class) { OneviewSDK::API300::Synergy::EthernetNetwork }

  include_examples 'InterconnectUpdateExample', 'integration api300 context'
end
