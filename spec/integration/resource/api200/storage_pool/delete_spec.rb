require 'spec_helper'

klass = OneviewSDK::StoragePool
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'StoragePoolDeleteExample', 'integration context' do
    let(:current_client) { $client }
  end
end
