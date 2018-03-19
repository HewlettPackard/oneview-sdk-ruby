require 'spec_helper'

klass = OneviewSDK::API600::C7000::LogicalEnclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600 }
  include_examples 'LogicalEnclosureCreateExample', 'integration api600 context', 'C7000'
end
