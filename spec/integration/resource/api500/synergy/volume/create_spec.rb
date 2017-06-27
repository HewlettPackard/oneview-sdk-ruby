require 'spec_helper'

klass = OneviewSDK::API500::Synergy::Volume
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }
  let(:storage_system_ip) { $secrets_synergy['storage_system1_ip'] }
  let(:storage_virtual_ip) { $secrets_synergy['store_virtual_ip'] }
  include_examples 'From500VolumeCreateExample', 'integration api500 context'
end
