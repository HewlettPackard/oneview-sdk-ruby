require 'spec_helper'

klass = OneviewSDK::API600::C7000::LogicalInterconnect
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  # Cannot delete individually
end
