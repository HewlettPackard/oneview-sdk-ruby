require 'spec_helper'

klass = OneviewSDK::API500::Synergy::ServerHardwareType
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api500 context'
  let(:current_client) { $client_500_synergy }
  let(:server_hardware) { OneviewSDK::API500::Synergy::ServerHardware.get_all(current_client).first }

  include_examples 'ServerHardwareTypeDeleteExample', 'integration api500 context'
end
