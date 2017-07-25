require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::ClientCertificate, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  let(:current_secrets) { $secrets }
  include_examples 'ClientCertificateUpdateExample', 'integration api500 context'
end
