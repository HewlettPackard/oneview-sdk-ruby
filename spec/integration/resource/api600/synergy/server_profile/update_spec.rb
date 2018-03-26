require 'spec_helper'

klass = OneviewSDK::API600::Synergy::ServerProfile
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600_synergy }
  let(:server_hardware_type_name) { SERVER_HARDWARE_TYPE2_NAME }
  let(:storage_system_ip) { $secrets_synergy['storage_system1_ip'] }
  include_examples 'ServerProfileUpdateExample', 'integration api600 context'
end
