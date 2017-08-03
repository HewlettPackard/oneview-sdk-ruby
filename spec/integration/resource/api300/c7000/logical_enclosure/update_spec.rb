require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalEnclosure
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  let(:encl_name) { ENCL_NAME }
  include_examples 'LogicalEnclosureUpdateExample', 'integration api300 context', 300, 'C7000'
end
