require 'spec_helper'

klass = OneviewSDK::API300::C7000::VolumeAttachment
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  include_examples 'VolumeAttachmentUpdateExample', 'integration api300 context', api_version: 300
end
