require 'spec_helper'

klass = OneviewSDK::API500::C7000::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do

  let(:store_serv_data) do
    {
      credentials: {
        username: $secrets['storage_system1_user'],
        password: $secrets['storage_system1_password']
      },
      hostname: $secrets['storage_system1_ip'],
      family: 'StoreServ'
    }
  end

  it_behaves_like 'StorageSystemUpdateExample', 'integration api500 context', 500 do
    let(:current_client) { $client_500 }
    let(:item_attributes) { store_serv_data }

    include_examples 'StorageSystemUpdateExample StoreServ API500'
  end
end
