require 'spec_helper'

klass = OneviewSDK::API300::Synergy::Enclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_300_synergy }

  include_examples 'EnclosureDeleteExample', 'integration api300 context', 'Synergy'
  include_context 'integration api300 context'
end
