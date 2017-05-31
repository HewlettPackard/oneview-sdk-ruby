require 'spec_helper'

klass = OneviewSDK::API500::Synergy::LogicalInterconnect
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  # Cannot create individually
end
