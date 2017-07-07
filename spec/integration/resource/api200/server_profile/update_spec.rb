require 'spec_helper'

RSpec.describe OneviewSDK::ServerProfile, integration: true, type: UPDATE do
  let(:current_client) { $client }
  let(:server_hardware_type_name) { SERVER_HARDWARE_TYPE_NAME }
  let(:storage_system_ip) { $secrets['storage_system1_ip']}
  include_examples 'ServerProfileUpdateExample', 'integration context'
end
