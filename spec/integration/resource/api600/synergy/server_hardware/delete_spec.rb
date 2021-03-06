require 'spec_helper'

klass = OneviewSDK::API600::Synergy::ServerHardware
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_600_synergy }
  let(:hostname) { $secrets_synergy['server_hardware_ip'] }
  include_examples 'ServerHardwareDeleteExample', 'integration api600 context'
end
