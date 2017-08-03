require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ServerHardwareType
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  include_examples 'ServerHardwareTypeUpdateExample', 'integration api300 context'
end
