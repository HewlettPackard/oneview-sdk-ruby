require 'spec_helper'

klass = OneviewSDK::Version
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  include_examples 'VersionCreateExample', 'integration context'
end
