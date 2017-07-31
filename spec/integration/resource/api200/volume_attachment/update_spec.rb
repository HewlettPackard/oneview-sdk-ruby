require 'spec_helper'

klass = OneviewSDK::VolumeAttachment
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'VolumeAttachmentUpdateExample', 'integration context', api_version: 200
end
