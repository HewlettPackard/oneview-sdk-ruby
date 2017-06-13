require 'spec_helper'

RSpec.describe OneviewSDK::ServerHardware, integration: true, type: UPDATE do
  let(:current_client) { $client }
  let(:hostname) { $secrets['server_hardware_ip'] }
  include_examples 'ServerHardwareUpdateExample', 'integration context', 200
end
