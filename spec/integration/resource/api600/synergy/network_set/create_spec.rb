require 'spec_helper'

klass = OneviewSDK::API600::Synergy::NetworkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600_synergy }
  let(:ethernet_class) { OneviewSDK::API600::Synergy::EthernetNetwork }

  include_examples 'NetworkSetCreateExample', 'integration api600 context'
end
