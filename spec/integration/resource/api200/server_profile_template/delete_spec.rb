require 'spec_helper'

klass = OneviewSDK::ServerProfileTemplate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'ServerProfileTemplateDeleteExample', 'integration context'
end
