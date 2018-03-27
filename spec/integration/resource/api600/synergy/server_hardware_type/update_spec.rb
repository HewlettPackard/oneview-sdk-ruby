require 'spec_helper'

klass = OneviewSDK::API600::Synergy::ServerHardwareType
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600_synergy }
  include_examples 'ServerHardwareTypeUpdateExample', 'integration api600 context'
end
