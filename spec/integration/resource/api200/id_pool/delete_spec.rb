require 'spec_helper'

klass = OneviewSDK::IDPool
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'IDPoolDeleteExample', 'integration context'
end
