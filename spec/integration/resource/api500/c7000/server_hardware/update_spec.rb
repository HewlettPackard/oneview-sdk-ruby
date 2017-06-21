require 'spec_helper'

klass = OneviewSDK::API500::C7000::ServerHardware
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  let(:hostname) { $secrets['server_hardware_ip'] }

  include_examples 'ServerHardwareUpdateExample', 'integration api500 context', 500

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API500::C7000::Scope do
    let(:item) { described_class.get_all(current_client).first }
  end
end
