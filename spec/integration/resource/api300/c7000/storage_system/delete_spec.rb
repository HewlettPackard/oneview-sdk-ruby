require 'spec_helper'

klass = OneviewSDK::API300::C7000::StorageSystem
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'StorageSystemDeleteExample', 'integration api300 context' do
    let(:current_client) { $client_300 }
    let(:item_attributes) { { 'credentials' => { ip_hostname: $secrets['storage_system1_ip'] } } }
  end
end
