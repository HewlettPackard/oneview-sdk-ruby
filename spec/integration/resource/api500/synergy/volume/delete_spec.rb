require 'spec_helper'

klass = OneviewSDK::API500::Synergy::Volume
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_500_synergy }
  include_examples 'VolumeDeleteExample', 'integration api500 context'
  include_examples 'From500VolumeDeleteExample', 'integration api500 context'
end