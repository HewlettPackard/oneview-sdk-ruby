require 'spec_helper'

klass = OneviewSDK::Interconnect
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  # Cannot create individually
end
