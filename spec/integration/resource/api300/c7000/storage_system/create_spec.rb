require 'spec_helper'

klass = OneviewSDK::API300::C7000::StorageSystem
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'StorageSystemCreateExample', 'integration api300 context', 300 do
    let(:current_client) { $client_300 }
    let(:item_attributes) do
      {
        credentials: {
          ip_hostname: $secrets['storage_system1_ip'],
          username: $secrets['storage_system1_user'],
          password: $secrets['storage_system1_password']
        },
        managedDomain: 'TestDomain'
      }
    end
  end
end
