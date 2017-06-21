require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerHardware
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  let(:hostname) { $secrets['server_hardware_ip'] }

  include_examples 'ServerHardwareUpdateExample', 'integration api300 context', 300

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
