require 'spec_helper'

klass = OneviewSDK::API500::C7000::Fabric
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500 }
  include_examples 'FabricCreateExample', 'integration api500 context'
end
