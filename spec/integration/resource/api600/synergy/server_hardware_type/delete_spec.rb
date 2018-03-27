require 'spec_helper'

klass = OneviewSDK::API600::Synergy::ServerHardwareType
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api600 context'
  let(:current_client) { $client_600_synergy }
  let(:server_hardware) { OneviewSDK::API600::Synergy::ServerHardware.get_all(current_client).first }

  include_examples 'ServerHardwareTypeDeleteExample', 'integration api600 context'
end
