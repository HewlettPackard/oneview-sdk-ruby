require 'spec_helper'

RSpec.describe OneviewSDK::Interconnect, integration: true, type: DELETE, sequence: 7 do
  include_context 'integration context'

  # Cannot delete individually
end
