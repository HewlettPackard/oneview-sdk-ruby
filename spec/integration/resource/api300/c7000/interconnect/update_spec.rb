require 'spec_helper'

klass = OneviewSDK::API300::C7000::Interconnect
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  let(:interconnect_name) { INTERCONNECT_2_NAME }
  let(:ethernet_class) { OneviewSDK::API300::C7000::EthernetNetwork }

  include_examples 'InterconnectUpdateExample', 'integration api300 context'
end
