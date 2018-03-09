require 'spec_helper'

klass = OneviewSDK::API500::C7000::Volume
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500 }
  let(:storage_system_ip) { $secrets['storage_system1_ip'] }
  let(:storage_virtual_ip) { $secrets['store_virtual_ip'] }
  include_examples 'VolumeCreateExample API500', 'integration api500 context'
end
