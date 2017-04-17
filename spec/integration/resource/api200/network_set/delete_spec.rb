require 'spec_helper'

klass = OneviewSDK::NetworkSet
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'NetworkSetDeleteExample', 'integration context'
end
