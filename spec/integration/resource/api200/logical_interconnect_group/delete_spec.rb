require 'spec_helper'

klass = OneviewSDK::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'LIGC7000DeleteExample', 'integration context'
end
