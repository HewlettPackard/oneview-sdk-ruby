require 'spec_helper'

RSpec.describe OneviewSDK::StoragePool, integration: true, type: UPDATE do
  include_examples 'StoragePoolUpdateExample', 'integration context' do
    let(:current_client) { $client }
  end
end
