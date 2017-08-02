require 'spec_helper'

klass = OneviewSDK::LogicalSwitch
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'LogicalSwitchDeleteExample', 'integration context'
end
