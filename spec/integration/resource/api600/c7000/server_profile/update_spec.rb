require 'spec_helper'

klass = OneviewSDK::API600::C7000::ServerProfile
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  let(:server_hardware_type_name) { SERVER_HARDWARE_TYPE_NAME }
  let(:storage_system_ip) { $secrets['storage_system1_ip'] }
  include_examples 'ServerProfileUpdateExample', 'integration api600 context'
end
