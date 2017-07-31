require 'spec_helper'

RSpec.describe OneviewSDK::VolumeTemplate, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'VolumeTemplateUpdateExample', 'integration context'
end
