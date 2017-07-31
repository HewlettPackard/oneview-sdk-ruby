require 'spec_helper'

klass = OneviewSDK::API300::C7000::Volume
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  let(:storage_system_ip) { $secrets['storage_system1_ip'] }
  include_examples 'VolumeCreateExample', 'integration api300 context'
end
