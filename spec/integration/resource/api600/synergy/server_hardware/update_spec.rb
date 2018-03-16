require 'spec_helper'

klass = OneviewSDK::API600::Synergy::ServerHardware
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600_synergy }
  let(:hostname) { $secrets_synergy['server_hardware_ip'] }

  include_examples 'ServerHardwareUpdateExample', 'integration api600 context', 600

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API600::Synergy::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
