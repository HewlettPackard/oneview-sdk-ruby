require 'spec_helper'

klass = OneviewSDK::API600::C7000::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do

  let(:store_serv_data) do
    {
      credentials: {
        username: $secrets['storage_system1_user'],
        password: $secrets['storage_system1_password']
      },
      hostname: $secrets['storage_system2_ip'],
      family: 'StoreServ'
    }
  end

  it_behaves_like 'StorageSystemUpdateExample', 'integration api600 context', 600 do
    let(:current_client) { $client_600 }
    let(:item_attributes) { store_serv_data }

    include_examples 'StorageSystemUpdateExample StoreServ API600'
  end
end
