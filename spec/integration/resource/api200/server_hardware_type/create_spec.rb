require 'spec_helper'

klass = OneviewSDK::ServerHardwareType
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:server_hardware_class) { OneviewSDK::ServerHardware }
  include_examples 'ServerHardwareTypeCreateExample', 'integration context', true
end
