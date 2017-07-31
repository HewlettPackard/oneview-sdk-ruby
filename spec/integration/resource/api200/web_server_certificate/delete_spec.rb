require 'spec_helper'

klass = OneviewSDK::WebServerCertificate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client }
  include_examples 'WebServerCertificateDeleteExample', 'integration context'
end
