require 'spec_helper'

klass = OneviewSDK::API500::Synergy::ServerProfile
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }
  let(:storage_system_ip) { $secrets_synergy['storage_system1_ip'] }
  let(:server_hardware_type_name) { SERVER_HARDWARE_TYPE2_NAME }
  include_examples 'ServerProfileCreateExample', 'integration api500 context'
  include_examples 'ServerProfileCreateExample Synergy', 'integration api500 context'
end
