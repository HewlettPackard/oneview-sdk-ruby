require 'spec_helper'

klass = OneviewSDK::StorageSystem
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'StorageSystemDeleteExample', 'integration context' do
    let(:current_client) { $client }
    let(:item_attributes) { { 'credentials' => { ip_hostname: $secrets['storage_system1_ip'] } } }
  end
end
