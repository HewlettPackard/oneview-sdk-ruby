require 'spec_helper'

klass = OneviewSDK::Fabric
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'FabricDeleteExample', 'integration context'
end
