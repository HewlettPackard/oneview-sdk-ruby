require 'spec_helper'

klass = OneviewSDK::ClientCertificate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  let(:current_secrets) { $secrets }
  include_examples 'ClientCertificateDeleteExample', 'integration context'
end
