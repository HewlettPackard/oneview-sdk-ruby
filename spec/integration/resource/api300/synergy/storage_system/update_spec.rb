require 'spec_helper'

klass = OneviewSDK::API300::Synergy::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do
  include_examples 'StorageSystemUpdateExample', 'integration api300 context', 300 do
    let(:current_client) { $client_300_synergy }
    let(:item_attributes) do
      {
        credentials: {
          username: $secrets_synergy['storage_system1_user'],
          password: $secrets_synergy['storage_system1_password'],
          ip_hostname: $secrets_synergy['storage_system1_ip']
        }
      }
    end
  end
end
