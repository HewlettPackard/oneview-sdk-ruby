require 'spec_helper'

klass = OneviewSDK::Interconnect
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client }
  let(:ethernet_class) { OneviewSDK::EthernetNetwork }

  include_examples 'InterconnectUpdateExample', 'integration context'
end
