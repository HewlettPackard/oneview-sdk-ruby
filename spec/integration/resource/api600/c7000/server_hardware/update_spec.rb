require 'spec_helper'

klass = OneviewSDK::API600::C7000::ServerHardware
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  let(:hostname) { $secrets['server_hardware_ip'] }

  include_examples 'ServerHardwareUpdateExample', 'integration api600 context', 600

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API600::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
