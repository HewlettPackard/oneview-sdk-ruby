require 'spec_helper'

klass = OneviewSDK::API300::C7000::VolumeTemplate
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client_300 }
  let(:current_secrets) { $secrets }
  include_examples 'VolumeTemplateCreateExample', 'integration api300 context'
end
