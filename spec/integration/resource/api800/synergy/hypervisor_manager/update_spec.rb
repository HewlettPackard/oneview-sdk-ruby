require 'spec_helper'

RSpec.describe OneviewSDK::API800::Synergy::HypervisorManager, integration: true, type: UPDATE do
  include_examples 'HypervisorManagerUpdateExample', 'integration api800 context' do
    let(:current_client) { $client_800 }
  end
end
