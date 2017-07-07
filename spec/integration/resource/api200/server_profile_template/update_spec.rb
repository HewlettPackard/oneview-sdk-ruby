require 'spec_helper'

RSpec.describe OneviewSDK::ServerProfileTemplate, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'ServerProfileTemplateUpdateExample', 'integration context'
end
