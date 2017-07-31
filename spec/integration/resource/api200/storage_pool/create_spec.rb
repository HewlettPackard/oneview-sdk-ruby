require 'spec_helper'

klass = OneviewSDK::StoragePool
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'StoragePoolCreateExample', 'integration context' do
    let(:current_client) { $client }
  end
end
