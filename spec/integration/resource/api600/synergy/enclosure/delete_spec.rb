require 'spec_helper'

klass = OneviewSDK::API600::Synergy::Enclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_600_synergy }

  include_examples 'EnclosureDeleteExample', 'integration api600 context', 'Synergy'
  include_context 'integration api600 context'
end
