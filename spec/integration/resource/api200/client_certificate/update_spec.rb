require 'spec_helper'

RSpec.describe OneviewSDK::ClientCertificate, integration: true, type: UPDATE do
  let(:current_client) { $client }
  let(:current_secrets) { $secrets }
  include_examples 'ClientCertificateUpdateExample', 'integration context'
end
