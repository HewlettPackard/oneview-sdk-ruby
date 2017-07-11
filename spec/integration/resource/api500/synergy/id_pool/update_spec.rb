require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::IDPool, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  include_examples 'IDPoolUpdateExample', 'integration api500 context'
end
