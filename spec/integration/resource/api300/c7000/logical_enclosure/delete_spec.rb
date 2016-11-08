require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalEnclosure
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  include_context 'integration api300 context'

  it 'is a pending example'
end
