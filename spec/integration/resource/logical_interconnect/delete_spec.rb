require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnect, integration: true, type: DELETE, sequence: 6 do
  include_context 'integration context'

  # Cannot delete individually
end
