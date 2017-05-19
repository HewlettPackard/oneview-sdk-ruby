require 'spec_helper'

klass = OneviewSDK::LogicalDownlink
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'LogicalDownlinkDeleteExample', 'integration context'
end
