require 'spec_helper'

klass = OneviewSDK::Enclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:encl_group_class) { OneviewSDK::EnclosureGroup }

  include_examples 'EnclosureCreateExample', 'integration context', 'C7000'
end
