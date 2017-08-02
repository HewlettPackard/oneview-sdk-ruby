require 'spec_helper'

klass = OneviewSDK::API300::C7000::ConnectionTemplate
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  include_examples 'ConnectionTemplateUpdateExample', 'integration api300 context'
end
