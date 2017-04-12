require 'spec_helper'

klass = OneviewSDK::API500::C7000::NetworkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500 }
  let(:ethernet_class) { OneviewSDK::API500::C7000::EthernetNetwork }

  include_examples 'NetworkSetCreateExample', 'integration api500 context'
end
