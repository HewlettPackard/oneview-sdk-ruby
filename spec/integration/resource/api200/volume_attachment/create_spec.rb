require 'spec_helper'

klass = OneviewSDK::VolumeAttachment
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  include_examples 'VolumeAttachmentCreateExample', 'integration context'
end
