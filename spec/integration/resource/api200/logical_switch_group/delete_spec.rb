require 'spec_helper'

klass = OneviewSDK::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'LogicalSwitchGroupDeleteExample', 'integration context'
end
