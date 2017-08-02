require 'spec_helper'

klass = OneviewSDK::Switch
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'SwitchDeleteExample', 'integration context'
end
