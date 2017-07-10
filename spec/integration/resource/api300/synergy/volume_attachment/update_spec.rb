require 'spec_helper'

klass = OneviewSDK::API300::Synergy::VolumeAttachment
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  include_examples 'VolumeAttachmentUpdateExample', 'integration api300 context', api_version: 300
end
