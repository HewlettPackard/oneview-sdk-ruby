require 'spec_helper'

klass = OneviewSDK::API500::C7000::ConnectionTemplate
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  include_examples 'ConnectionTemplateUpdateExample', 'integration api500 context'
end
