require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::ClientCertificate, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  let(:current_secrets) { $secrets_synergy }
  include_examples 'ClientCertificateUpdateExample', 'integration api500 context'
end
