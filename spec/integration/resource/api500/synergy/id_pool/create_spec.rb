require 'spec_helper'

klass = OneviewSDK::API500::Synergy::IDPool
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }
  include_examples 'IDPoolCreateExample', 'integration api500 context'
end
