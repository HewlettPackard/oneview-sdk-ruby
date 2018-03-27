require 'spec_helper'

klass = OneviewSDK::API600::Synergy::ServerHardwareType
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600_synergy }
  include_examples 'ServerHardwareTypeCreateExample', 'integration api600 context'
end
