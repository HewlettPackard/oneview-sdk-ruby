require 'spec_helper'

klass = OneviewSDK::API300::Synergy::LogicalEnclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300_synergy }
  let(:encl_group_class) { OneviewSDK::API300::Synergy::EnclosureGroup }
  let(:enclosure_class) { OneviewSDK::API300::Synergy::Enclosure }

  include_examples 'LogicalEnclosureCreateExample', 'integration api300 context', 'Synergy'
end
