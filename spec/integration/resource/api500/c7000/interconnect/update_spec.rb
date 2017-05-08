require 'spec_helper'

klass = OneviewSDK::API500::C7000::Interconnect
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  let(:interconnect_name) { INTERCONNECT_2_NAME }
  let(:ethernet_class) { OneviewSDK::API500::C7000::EthernetNetwork }

  include_examples 'InterconnectUpdateExample', 'integration api500 context'
end
