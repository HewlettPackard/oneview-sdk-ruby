require 'spec_helper'

klass = OneviewSDK::API300::C7000::VolumeTemplate
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  include_examples 'VolumeTemplateUpdateExample', 'integration api300 context'
end
