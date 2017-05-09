require 'spec_helper'

klass = OneviewSDK::API500::C7000::ServerHardwareType
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  include_examples 'ServerHardwareTypeUpdateExample', 'integration api500 context'
end
