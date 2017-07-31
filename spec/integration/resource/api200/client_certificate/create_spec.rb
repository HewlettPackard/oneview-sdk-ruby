require 'spec_helper'

klass = OneviewSDK::ClientCertificate
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:current_secrets) { $secrets }
  include_examples 'ClientCertificateCreateExample', 'integration context'
end
