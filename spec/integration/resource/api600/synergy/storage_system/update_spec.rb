require 'spec_helper'

klass = OneviewSDK::API600::Synergy::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do
  let(:store_serv_data) do
    {
      credentials: {
        username: $secrets_synergy['storage_system2_user'],
        password: $secrets_synergy['storage_system2_password']
      },
      hostname: $secrets_synergy['storage_system2_ip'],
      family: 'StoreServ'
    }
  end

  it_behaves_like 'StorageSystemUpdateExample', 'integration api600 context', 600 do
    let(:current_client) { $client_600_synergy }
    let(:item_attributes) { store_serv_data }

    include_examples 'StorageSystemUpdateExample StoreServ API600'
  end
end
