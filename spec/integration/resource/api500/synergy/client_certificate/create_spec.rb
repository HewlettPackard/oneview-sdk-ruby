require 'spec_helper'

klass = OneviewSDK::API500::Synergy::ClientCertificate
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_500_synergy }
  let(:current_secrets) { $secrets_synergy }
  include_examples 'ClientCertificateCreateExample', 'integration api500 context'
end
