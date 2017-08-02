require 'spec_helper'

klass = OneviewSDK::API500::C7000::StorageSystem
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do

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

  let(:store_serv_data_with_domain) do
    {
      credentials: {
        username: $secrets['storage_system1_user'],
        password: $secrets['storage_system1_password']
      },
      hostname: $secrets['storage_system2_ip'],
      family: 'StoreServ',
      deviceSpecificAttributes: {
        managedDomain: 'TestDomain'
      }
    }
  end

  let(:store_virtual_data) do
    {
      credentials: {
        username: $secrets['store_virtual_user'],
        password: $secrets['store_virtual_password']
      },
      hostname: $secrets['store_virtual_ip'],
      family: 'StoreVirtual',
      name: 'StoreVirtual Name'
    }
  end

  it_behaves_like 'StorageSystemCreateExample', 'integration api500 context', 500 do
    let(:current_client) { $client_500 }
    let(:item_attributes) { store_serv_data }
  end

  it_behaves_like 'StorageSystemCreateExample', 'integration api500 context', 500 do
    let(:current_client) { $client_500 }
    let(:item_attributes) { store_virtual_data }
  end

  it_behaves_like 'StorageSystemCreateExample', 'integration api500 context', 500 do
    let(:current_client) { $client_500 }
    let(:item_attributes) { store_serv_data_with_domain }

    describe 'verifying managedDomain' do
      it 'it should have been added' do
        item = described_class.find_by(current_client, hostname: item_attributes[:hostname]).first
        expected_domain = item_attributes[:deviceSpecificAttributes][:managedDomain]
        expect(item['deviceSpecificAttributes']['managedDomain']).to eq(expected_domain)
      end
    end
  end
end
