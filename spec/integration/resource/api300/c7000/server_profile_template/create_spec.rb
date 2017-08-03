require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerProfileTemplate
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  let(:storage_system_ip) { $secrets['storage_system1_ip'] }
  let(:server_hardware_type_name) { SERVER_HARDWARE_TYPE_NAME }
  include_examples 'ServerProfileTemplateCreateExample', 'integration api300 context'
end
