require 'spec_helper'

klass = OneviewSDK::API500::C7000::ServerHardware
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_500 }
  let(:hostname) { $secrets['server_hardware_ip'] }
  let(:hostname2) { $secrets['rack_server_hardware_ip'] }
  include_examples 'ServerHardwareDeleteExample', 'integration api500 context', true
end
