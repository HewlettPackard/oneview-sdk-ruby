require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::IDPool, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  include_examples 'IDPoolUpdateExample', 'integration api500 context'
end
