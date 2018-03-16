require 'spec_helper'

klass = OneviewSDK::API600::Synergy::LogicalInterconnect
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  # Cannot delete individually
end
