require 'spec_helper'

klass = OneviewSDK::ConnectionTemplate
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'ConnectionTemplateUpdateExample', 'integration context'
end
