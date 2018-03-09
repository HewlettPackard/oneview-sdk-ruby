require 'spec_helper'

klass = OneviewSDK::API500::C7000::Enclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500 }
  let(:encl_group_class) { OneviewSDK::API500::C7000::EnclosureGroup }

  include_examples 'EnclosureCreateExample', 'integration api500 context', 'C7000'
end
