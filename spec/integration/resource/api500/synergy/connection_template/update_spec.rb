require 'spec_helper'

klass = OneviewSDK::API500::Synergy::ConnectionTemplate
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  include_examples 'ConnectionTemplateUpdateExample', 'integration api500 context'
end
