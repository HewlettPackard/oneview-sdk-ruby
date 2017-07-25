require 'spec_helper'

klass = OneviewSDK::API500::C7000::IDPool
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500 }
  include_examples 'IDPoolCreateExample', 'integration api500 context'
end
