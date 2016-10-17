require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::SASLogicalInterconnect
RSpec.describe klass, integration: true, type: DELETE, sequence: rseq(klass) do
  # Cannot delete individually
end
