require 'spec_helper'

klass = OneviewSDK::API500::C7000::ServerProfileTemplate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_500 }
  include_examples 'ServerProfileTemplateDeleteExample', 'integration api500 context'
end
