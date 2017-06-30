require 'spec_helper'

klass = OneviewSDK::WebServerCertificate
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:current_secrets) { $secrets }
  include_examples 'WebServerCertificateCreateExample', 'integration context'
end
