require 'spec_helper'

klass = OneviewSDK::API600::Synergy::LogicalEnclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_600_synergy }
  let(:encl_group_class) { OneviewSDK::API600::Synergy::EnclosureGroup }
  let(:enclosure_class) { OneviewSDK::API600::Synergy::Enclosure }

  include_examples 'LogicalEnclosureCreateExample', 'integration api600 context', 'Synergy'
end
