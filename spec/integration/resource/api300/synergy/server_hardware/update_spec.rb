require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ServerHardware
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  let(:hostname) { $secrets_synergy['server_hardware_ip'] }

  include_examples 'ServerHardwareUpdateExample', 'integration api300 context', 300

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::Synergy::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
