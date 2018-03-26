require 'spec_helper'

klass = OneviewSDK::API800::Synergy::ServerProfileTemplate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_800_synergy }
  include_examples 'ServerProfileTemplateDeleteExample', 'integration api800 context'
end
