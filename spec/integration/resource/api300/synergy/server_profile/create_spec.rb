# Requirements:
# => 2 Server Hardware Types (any name)
# => Enclosure Group 'EnclosureGroup_1' (configured with HPE Image Streamer deployment network)
# => Storage System (any name)
# => FC Network 'FCNetwork_1' (it has to be associated to the LIG 'EnclosureGroup_1' is associated to)
# => Volume 'Volume_4'
# => Storage Pool 'CPG-SSD-AO'
# => Server Profile Template (any name)
# => OS Deployment Plan 'HPE - Developer 1.0 - Deployment Test (UEFI)'

require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ServerProfile
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300_synergy }
  let(:storage_system_ip) { $secrets_synergy['storage_system1_ip'] }
  let(:server_hardware_type_name) { SERVER_HARDWARE_TYPE2_NAME }
  include_examples 'ServerProfileCreateExample', 'integration api300 context'
  include_examples 'ServerProfileCreateExample Synergy', 'integration api300 context'
end
