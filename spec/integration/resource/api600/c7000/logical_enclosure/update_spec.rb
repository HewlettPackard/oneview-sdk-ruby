require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalEnclosure
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  let(:encl_name) { ENCL_NAME }
  include_examples 'LogicalEnclosureUpdateExample', 'integration api500 context', 500, 'C7000'
end
