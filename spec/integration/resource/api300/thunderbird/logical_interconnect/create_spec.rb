require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalInterconnect
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  # Cannot create individually
end
