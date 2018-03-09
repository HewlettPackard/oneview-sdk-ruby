require 'spec_helper'

klass = OneviewSDK::API500::Synergy::ClientCertificate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_500_synergy }
  let(:current_secrets) { $secrets_synergy }
  include_examples 'ClientCertificateDeleteExample', 'integration api500 context'
end
