require 'spec_helper'

klass = OneviewSDK::API600::C7000::LogicalEnclosure
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_600 }
  let(:encl_name) { ENCL_NAME }
  include_examples 'LogicalEnclosureUpdateExample', 'integration api600 context', 600, 'C7000'
end
