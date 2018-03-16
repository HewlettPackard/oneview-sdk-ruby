require 'spec_helper'

klass = OneviewSDK::API600::C7000::ServerHardware
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_600 }
  let(:hostname) { $secrets['server_hardware_ip'] }
  let(:hostname2) { $secrets['rack_server_hardware_ip'] }
  include_examples 'ServerHardwareDeleteExample', 'integration api600 context', true
end
