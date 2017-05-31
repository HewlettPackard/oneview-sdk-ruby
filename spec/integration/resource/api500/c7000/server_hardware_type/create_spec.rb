require 'spec_helper'

klass = OneviewSDK::API500::C7000::ServerHardwareType
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500 }
  let(:server_hardware_class) { OneviewSDK::API500::C7000::ServerHardware }
  include_examples 'ServerHardwareTypeCreateExample', 'integration api500 context', true
end
