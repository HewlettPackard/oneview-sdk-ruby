require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::ServerProfileTemplate, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  include_examples 'ServerProfileTemplateUpdateExample', 'integration api600 context'
end
