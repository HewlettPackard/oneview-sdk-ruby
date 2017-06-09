require 'spec_helper'

klass = OneviewSDK::IDPool
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  include_examples 'IDPoolCreateExample', 'integration context'
end
