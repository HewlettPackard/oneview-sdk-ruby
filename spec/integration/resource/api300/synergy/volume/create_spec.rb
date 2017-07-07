require 'spec_helper'

klass = OneviewSDK::API300::Synergy::Volume
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300_synergy }
  let(:storage_system_ip) { $secrets_synergy['storage_system1_ip'] }
  include_examples 'VolumeCreateExample', 'integration api300 context'
end
