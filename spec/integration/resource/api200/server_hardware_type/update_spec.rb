require 'spec_helper'

klass = OneviewSDK::ServerHardwareType
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'ServerHardwareTypeUpdateExample', 'integration context'
end
