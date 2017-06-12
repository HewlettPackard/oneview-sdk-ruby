require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::LogicalEnclosure, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  let(:encl_name) { LOG_ENCL1_NAME }
  include_examples 'LogicalEnclosureUpdateExample', 'integration api500 context', 500, 'Synergy'
end
