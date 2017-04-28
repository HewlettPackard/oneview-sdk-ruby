require 'spec_helper'

RSpec.describe OneviewSDK::LogicalEnclosure, integration: true, type: UPDATE do
  include_context 'integration context'
  let(:current_client) { $client }
  let(:encl_name) { ENCL_NAME }

  include_examples 'LogicalEnclosureUpdateExample', 'integration context', 200
end
