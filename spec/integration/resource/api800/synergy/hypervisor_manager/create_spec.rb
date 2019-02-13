require 'spec_helper'

klass = OneviewSDK::API800::Synergy::HypervisorManager
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'HypervisorManagerCreateExample', 'integration api800 context' do
    let(:current_client) { $client_800 }
  end
end
