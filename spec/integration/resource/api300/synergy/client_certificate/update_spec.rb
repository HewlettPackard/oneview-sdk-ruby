require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::ClientCertificate, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  let(:current_secrets) { $secrets_synergy }
  include_examples 'ClientCertificateUpdateExample', 'integration api300 context'
end
