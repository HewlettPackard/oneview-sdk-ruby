require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::IDPool, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  include_examples 'IDPoolUpdateExample', 'integration api300 context'
end
