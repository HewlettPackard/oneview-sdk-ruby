require 'spec_helper'

klass = OneviewSDK::API600::C7000::ServerHardwareType
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  include_examples 'ServerHardwareTypeUpdateExample', 'integration api600 context'
end
