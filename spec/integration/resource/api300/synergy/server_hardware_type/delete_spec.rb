require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ServerHardwareType
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'
  let(:current_client) { $client_300_synergy }
  let(:server_hardware) { OneviewSDK::API300::Synergy::ServerHardware.get_all(current_client).first }

  include_examples 'ServerHardwareTypeDeleteExample', 'integration api300 context'
end
