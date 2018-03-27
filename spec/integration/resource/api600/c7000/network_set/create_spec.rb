require 'spec_helper'

klass = OneviewSDK::API600::C7000::NetworkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600 }
  let(:ethernet_class) { OneviewSDK::API600::C7000::EthernetNetwork }

  include_examples 'NetworkSetCreateExample', 'integration api600 context'
end
