require 'spec_helper'

klass = OneviewSDK::LoginDetail
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  let(:current_client) { $client }
  let(:login_detail_class) { OneviewSDK::LoginDetail }

  include_examples 'LoginDetailGetExample', 'integration context'
end
