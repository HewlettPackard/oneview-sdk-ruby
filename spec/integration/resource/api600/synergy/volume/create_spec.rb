require 'spec_helper'

klass = OneviewSDK::API600::Synergy::Volume
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600_synergy }
  let(:storage_system_ip) { $secrets_synergy['storage_system1_ip'] }
  let(:storage_virtual_ip) { $secrets_synergy['store_virtual_ip'] }
  include_examples 'VolumeCreateExample API600', 'integration api600 context'
end
