require 'spec_helper'

RSpec.describe OneviewSDK::API800::Synergy::ServerProfileTemplate, integration: true, type: UPDATE do
  let(:current_client) { $client_800_synergy }
  include_examples 'ServerProfileTemplateUpdateExample', 'integration api800 context'
end
