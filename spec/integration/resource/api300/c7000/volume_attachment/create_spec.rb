require 'spec_helper'

klass = OneviewSDK::API300::C7000::VolumeAttachment
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  include_examples 'VolumeAttachmentCreateExample', 'integration api300 context'
end
