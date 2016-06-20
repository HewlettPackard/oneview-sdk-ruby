require 'spec_helper'

klass = OneviewSDK::Interconnect
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  # Cannot delete individually
end
