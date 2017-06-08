require 'spec_helper'

klass = OneviewSDK::API300::Synergy::StorageSystem
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'StorageSystemCreateExample', 'integration api300 context', 300 do
    let(:current_client) { $client_300_synergy }
    let(:item_attributes) do
      {
        credentials: {
          ip_hostname: $secrets_synergy['storage_system1_ip'],
          username: $secrets_synergy['storage_system1_user'],
          password: $secrets_synergy['storage_system1_password']
        },
        managedDomain: 'TestDomain'
      }
    end
  end
end
