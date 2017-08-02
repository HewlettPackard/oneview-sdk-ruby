# Requirements:
# => 2 Server Hardware Types (any name)
# => Enclosure Group 'EnclosureGroup_1'
# => Storage System (any name)
# => Ethernet Network 'EthernetNetwork_1' (it has to be associated to the LIG 'EnclosureGroup_1' is associated to)
# => Volume 'Volume_4'
# => Storage Pool 'CPG-SSD-AO'
# => Server Profile Template (any name)

require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerProfile
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  let(:storage_system_ip) { $secrets['storage_system1_ip'] }
  let(:server_hardware_type_name) { SERVER_HARDWARE_TYPE_NAME }
  include_examples 'ServerProfileCreateExample', 'integration api300 context'
end
