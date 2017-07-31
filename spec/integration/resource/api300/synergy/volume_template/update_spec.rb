require 'spec_helper'

klass = OneviewSDK::API300::Synergy::VolumeTemplate
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300_synergy }
  include_examples 'VolumeTemplateUpdateExample', 'integration api300 context'
end
