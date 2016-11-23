require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::StorageSystem
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  describe '#remove' do
    it 'removes the storage system' do
      storage_system = klass.new($client_300_thunderbird, 'credentials' => {})
      storage_system['credentials']['ip_hostname'] = $secrets['storage_system1_ip']
      storage_system.retrieve!
      expect { storage_system.remove }.to_not raise_error
    end
  end
end
