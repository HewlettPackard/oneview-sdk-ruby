require 'spec_helper'

RSpec.describe OneviewSDK::API800::C7000::ServerProfileTemplate, integration: true, type: UPDATE do
  let(:current_client) { $client_800 }
  include_examples 'ServerProfileTemplateUpdateExample', 'integration api800 context'
end
