require 'spec_helper'

klass = OneviewSDK::API800::C7000::ServerProfileTemplate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_800 }
  include_examples 'ServerProfileTemplateDeleteExample', 'integration api800 context'
end
