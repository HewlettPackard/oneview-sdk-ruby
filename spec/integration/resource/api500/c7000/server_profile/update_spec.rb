require 'spec_helper'

klass = OneviewSDK::API500::C7000::ServerProfile
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  let(:server_hardware_type_name) { SERVER_HARDWARE_TYPE_NAME }
  let(:storage_system_ip) { $secrets['storage_system1_ip'] }
  include_examples 'ServerProfileUpdateExample', 'integration api500 context'
end
