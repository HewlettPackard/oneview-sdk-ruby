require 'spec_helper'

klass = OneviewSDK::LogicalEnclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration context'

  it 'is a pending example'
end
