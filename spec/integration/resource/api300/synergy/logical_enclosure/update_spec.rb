require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::LogicalEnclosure, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  let(:encl_name) { LOG_ENCL1_NAME }
  include_examples 'LogicalEnclosureUpdateExample', 'integration api300 context', 300, 'Synergy'
end
