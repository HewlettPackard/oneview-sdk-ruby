require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ServerHardwareType
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300_synergy }
  include_examples 'ServerHardwareTypeCreateExample', 'integration api300 context'
end
