require 'spec_helper'

klass = OneviewSDK::API600::C7000::Enclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600 }
  let(:encl_group_class) { OneviewSDK::API600::C7000::EnclosureGroup }

  include_examples 'EnclosureCreateExample', 'integration api600 context', 'C7000'
end
