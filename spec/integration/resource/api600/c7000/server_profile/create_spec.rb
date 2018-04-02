require 'spec_helper'

klass = OneviewSDK::API600::C7000::ServerProfile
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600 }
  let(:storage_system_ip) { $secrets['storage_system1_ip'] }
  let(:server_hardware_type_name) { SERVER_HARDWARE_TYPE_NAME }
  include_examples 'ServerProfileCreateExample', 'integration api600 context'
end
