require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::WebServerCertificate, integration: true, type: UPDATE do
  let(:current_client) { $client_500_synergy }
  include_examples 'WebServerCertificateUpdateExample', 'integration api500 context'
end
