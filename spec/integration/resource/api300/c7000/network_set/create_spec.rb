require 'spec_helper'

klass = OneviewSDK::API300::C7000::NetworkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  let(:ethernet_class) { OneviewSDK::API300::C7000::EthernetNetwork }

  include_examples 'NetworkSetCreateExample', 'integration api300 context'
end
