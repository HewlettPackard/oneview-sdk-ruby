require 'spec_helper'

klass = OneviewSDK::ServerHardwareType
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'
  let(:current_client) { $client }
  let(:server_hardware) { OneviewSDK::ServerHardware.find_by(current_client, name: $secrets['server_hardware2_ip']).first }

  include_examples 'ServerHardwareTypeDeleteExample', 'integration context', true
end
