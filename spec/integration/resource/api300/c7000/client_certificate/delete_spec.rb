require 'spec_helper'

klass = OneviewSDK::API300::C7000::ClientCertificate
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_300 }
  let(:current_secrets) { $secrets }
  include_examples 'ClientCertificateDeleteExample', 'integration api300 context'
end
