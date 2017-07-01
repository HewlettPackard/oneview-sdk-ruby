require 'spec_helper'

klass = OneviewSDK::API300::C7000::IDPool
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  include_examples 'IDPoolCreateExample', 'integration api300 context'
end
