require 'spec_helper'

RSpec.describe OneviewSDK::WebServerCertificate, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'WebServerCertificateUpdateExample', 'integration context'
end
