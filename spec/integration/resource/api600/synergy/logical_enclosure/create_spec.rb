require 'spec_helper'

klass = OneviewSDK::API500::Synergy::LogicalEnclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }
  let(:encl_group_class) { OneviewSDK::API500::Synergy::EnclosureGroup }
  let(:enclosure_class) { OneviewSDK::API500::Synergy::Enclosure }

  include_examples 'LogicalEnclosureCreateExample', 'integration api500 context', 'Synergy'
end
