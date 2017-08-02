require 'spec_helper'

klass = OneviewSDK::ServerHardware
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  let(:hostname) { $secrets['server_hardware_ip'] }
  let(:hostname2) { $secrets['rack_server_hardware_ip'] }
  include_examples 'ServerHardwareDeleteExample', 'integration context', true
end
