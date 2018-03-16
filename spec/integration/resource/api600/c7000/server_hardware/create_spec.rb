require 'spec_helper'

klass = OneviewSDK::API600::C7000::ServerHardware
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600 }
  include_examples 'ServerHardwareCreateExample', 'integration api600 context'
end
