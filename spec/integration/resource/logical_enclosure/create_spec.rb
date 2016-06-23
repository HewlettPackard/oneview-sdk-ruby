require 'spec_helper'

klass = OneviewSDK::LogicalEnclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  it 'is a pending example'
end
