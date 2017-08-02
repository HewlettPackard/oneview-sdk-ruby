require 'spec_helper'

klass = OneviewSDK::API500::Synergy::LogicalInterconnect
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  # Cannot delete individually
end
