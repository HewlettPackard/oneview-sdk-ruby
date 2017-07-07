require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::ServerProfileTemplate, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  include_examples 'ServerProfileTemplateUpdateExample', 'integration api500 context'
end
