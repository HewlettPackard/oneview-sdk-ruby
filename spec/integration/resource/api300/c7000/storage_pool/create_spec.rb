require 'spec_helper'

klass = OneviewSDK::API300::C7000::StoragePool
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_examples 'StoragePoolCreateExample', 'integration api300 context' do
    let(:current_client) { $client_300 }
  end
end
