require 'spec_helper'

klass = OneviewSDK::API600::C7000::ServerHardwareType
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api600 context'
  let(:current_client) { $client_600 }
  let(:server_hardware) { OneviewSDK::API600::C7000::ServerHardware.find_by(current_client, name: $secrets['server_hardware2_ip']).first }

  include_examples 'ServerHardwareTypeDeleteExample', 'integration api600 context', true
end
