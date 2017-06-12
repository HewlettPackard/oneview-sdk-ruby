require 'spec_helper'

klass = OneviewSDK::API500::Synergy::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do
  let(:store_serv_data) do
    {
      credentials: {
        username: $secrets_synergy['storage_system1_user'],
        password: $secrets_synergy['storage_system1_password']
      },
      hostname: $secrets_synergy['storage_system1_ip'],
      family: 'StoreServ'
    }
  end

  it_behaves_like 'StorageSystemUpdateExample', 'integration api500 context', 500 do
    let(:current_client) { $client_500_synergy }
    let(:item_attributes) { store_serv_data }

    include_examples 'StorageSystemUpdateExample StoreServ API500'
  end
end
