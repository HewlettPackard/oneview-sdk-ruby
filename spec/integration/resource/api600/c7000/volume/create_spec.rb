require 'spec_helper'

klass = OneviewSDK::API600::C7000::Volume
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600 }
  let(:storage_system_ip) { $secrets['storage_system1_ip'] }
  let(:storage_virtual_ip) { $secrets['store_virtual_ip'] }
  include_examples 'VolumeCreateExample API600', 'integration api600 context'
end
