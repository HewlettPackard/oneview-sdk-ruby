require 'spec_helper'

klass = OneviewSDK::API800::Synergy::ServerProfileTemplate
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_800_synergy }
  let(:storage_system_ip) { $secrets_synergy['storage_system1_ip'] }
  let(:server_hardware_type_name) { SERVER_HARDWARE_TYPE2_NAME }
  include_examples 'ServerProfileTemplateCreateExample API500', 'integration api800 context'
end
