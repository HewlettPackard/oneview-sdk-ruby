require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::ClientCertificate, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  let(:current_secrets) { $secrets }
  include_examples 'ClientCertificateUpdateExample', 'integration api300 context'
end
