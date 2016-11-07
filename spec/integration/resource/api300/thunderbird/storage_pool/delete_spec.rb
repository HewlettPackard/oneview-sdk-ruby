require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::StoragePool
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#remove' do
    it 'deletes the resource' do
      item = klass.new($client_300_thunderbird, name: STORAGE_POOL_NAME)
      item.retrieve!
      expect { item.remove }.to_not raise_error
    end
  end
end
