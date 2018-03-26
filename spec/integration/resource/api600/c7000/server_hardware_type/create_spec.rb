require 'spec_helper'

klass = OneviewSDK::API600::C7000::ServerHardwareType
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600 }
  let(:server_hardware_class) { OneviewSDK::API600::C7000::ServerHardware }
  include_examples 'ServerHardwareTypeCreateExample', 'integration api600 context', true
end
