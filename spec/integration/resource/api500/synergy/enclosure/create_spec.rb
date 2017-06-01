require 'spec_helper'

klass = OneviewSDK::API500::Synergy::Enclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }

  include_examples 'EnclosureCreateExample', 'integration api500 context', 'Synergy'
  include_context 'integration api500 context'
end
