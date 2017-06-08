require 'spec_helper'

klass = OneviewSDK::API500::Synergy::StorageSystem
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  it_behaves_like 'StorageSystemDeleteExample', 'integration api500 context' do
    let(:current_client) { $client_500_synergy }
    let(:item_attributes) { { hostname: $secrets_synergy['storage_system1_ip'] } }
  end

  it_behaves_like 'StorageSystemDeleteExample', 'integration api500 context' do
    let(:current_client) { $client_500_synergy }
    let(:item_attributes) { { hostname: $secrets_synergy['storage_system2_ip'] } }
  end

  it_behaves_like 'StorageSystemDeleteExample', 'integration api500 context' do
    let(:current_client) { $client_500_synergy }
    let(:item_attributes) { { hostname: $secrets_synergy['store_virtual_ip'] } }
  end
end
