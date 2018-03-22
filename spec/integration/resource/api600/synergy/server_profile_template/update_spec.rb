require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::ServerProfileTemplate, integration: true, type: UPDATE do
  let(:current_client) { $client_600_synergy }
  include_examples 'ServerProfileTemplateUpdateExample', 'integration api600 context'
end
