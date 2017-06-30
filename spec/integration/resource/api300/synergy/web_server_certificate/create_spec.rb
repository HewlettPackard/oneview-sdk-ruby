require 'spec_helper'

klass = OneviewSDK::API300::Synergy::WebServerCertificate
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300_synergy }
  let(:current_secrets) { $secrets_synergy }
  include_examples 'WebServerCertificateCreateExample', 'integration api300 context'
end
