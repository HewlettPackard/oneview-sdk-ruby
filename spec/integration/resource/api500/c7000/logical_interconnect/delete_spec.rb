require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalInterconnect
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  # Cannot delete individually
end
