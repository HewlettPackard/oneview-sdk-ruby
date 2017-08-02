require 'spec_helper'

klass = OneviewSDK::API500::C7000::StorageSystem
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  it_behaves_like 'StorageSystemDeleteExample', 'integration api500 context' do
    let(:current_client) { $client_500 }
    let(:item_attributes) { { hostname: $secrets['storage_system1_ip'] } }
  end

  it_behaves_like 'StorageSystemDeleteExample', 'integration api500 context' do
    let(:current_client) { $client_500 }
    let(:item_attributes) { { hostname: $secrets['storage_system2_ip'] } }
  end

  it_behaves_like 'StorageSystemDeleteExample', 'integration api500 context' do
    let(:current_client) { $client_500 }
    let(:item_attributes) { { hostname: $secrets['store_virtual_ip'] } }
  end
end
