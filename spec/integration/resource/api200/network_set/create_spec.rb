require 'spec_helper'

klass = OneviewSDK::NetworkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:ethernet_class) { OneviewSDK::EthernetNetwork }

  include_examples 'NetworkSetCreateExample', 'integration context'
end
