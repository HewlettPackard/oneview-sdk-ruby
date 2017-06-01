require 'spec_helper'

klass = OneviewSDK::API300::Synergy::StoragePool
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_examples 'StoragePoolDeleteExample', 'integration api300 context' do
    let(:current_client) { $client_300_synergy }
    let(:storage_system_options) do
      {
        credentials: {
          ip_hostname: $secrets_synergy['storage_system1_ip']
        }
      }
    end
  end
end
