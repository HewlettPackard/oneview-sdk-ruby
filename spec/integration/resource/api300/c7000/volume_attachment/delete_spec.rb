require 'spec_helper'

klass = OneviewSDK::API300::C7000::VolumeAttachment
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  let(:current_client) { $client_300 }
  include_examples 'VolumeAttachmentDeleteExample', 'integration api300 context'
end
