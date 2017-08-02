require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerHardwareType
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  let(:server_hardware_class) { OneviewSDK::API300::C7000::ServerHardware }
  include_examples 'ServerHardwareTypeCreateExample', 'integration api300 context', true
end
