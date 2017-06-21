require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ConnectionTemplate
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  include_examples 'ConnectionTemplateUpdateExample', 'integration api300 context'
end
