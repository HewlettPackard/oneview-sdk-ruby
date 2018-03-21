require 'spec_helper'

klass = OneviewSDK::API600::C7000::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_600 }
  include_examples 'LIGC7000DeleteExample', 'integration api600 context'
end
