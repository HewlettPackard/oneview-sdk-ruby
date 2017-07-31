require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::WebServerCertificate, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  include_examples 'WebServerCertificateUpdateExample', 'integration api300 context'
end
