require 'spec_helper'

klass = OneviewSDK::API500::C7000::VolumeAttachment
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_500 }
  include_examples 'VolumeAttachmentUpdateExample', 'integration api500 context', api_version: 500
end
