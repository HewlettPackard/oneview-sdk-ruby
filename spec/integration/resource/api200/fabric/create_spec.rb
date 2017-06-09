require 'spec_helper'

klass = OneviewSDK::Fabric
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  include_examples 'FabricCreateExample', 'integration context'
end
