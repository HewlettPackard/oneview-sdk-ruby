require 'spec_helper'

klass = OneviewSDK::Volume
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:storage_system_ip) { $secrets['storage_system1_ip'] }
  include_examples 'VolumeCreateExample', 'integration context'
end
