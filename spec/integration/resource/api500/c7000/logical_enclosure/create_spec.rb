require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalEnclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500 }
  include_examples 'LogicalEnclosureCreateExample', 'integration api500 context', 'C7000'
end
