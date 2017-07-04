require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::ServerProfileTemplate, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  include_examples 'ServerProfileTemplateUpdateExample', 'integration api500 context'
end
