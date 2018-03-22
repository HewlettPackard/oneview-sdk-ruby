require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::LogicalEnclosure, integration: true, type: UPDATE do
  let(:current_client) { $client_600_synergy }
  let(:encl_name) { LOG_ENCL1_NAME }
  include_examples 'LogicalEnclosureUpdateExample', 'integration api600 context', 600, 'Synergy'
end
