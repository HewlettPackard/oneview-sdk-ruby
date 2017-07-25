require 'spec_helper'

RSpec.describe OneviewSDK::IDPool, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'IDPoolUpdateExample', 'integration context'
end
