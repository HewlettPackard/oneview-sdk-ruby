require 'spec_helper'

klass = OneviewSDK::ServerHardware
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  include_examples 'ServerHardwareCreateExample', 'integration context'
end
