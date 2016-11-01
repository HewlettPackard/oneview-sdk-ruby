require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  # update doesn't work
end
