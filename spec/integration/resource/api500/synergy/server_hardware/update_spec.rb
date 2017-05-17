require 'spec_helper'

klass = OneviewSDK::API500::Synergy::ServerHardware
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  let(:hostname) { $secrets_synergy['server_hardware_ip'] }

  include_examples 'ServerHardwareUpdateExample', 'integration api500 context', 500

  # include_examples 'ScopeHelperMethodsExample', OneviewSDK::API500::Synergy::Scope do
  #   let(:item) { described_class.get_all(current_client).first }
  # end
end
