require 'spec_helper'

RSpec.describe OneviewSDK::Enclosure, integration: true, type: UPDATE do
  let(:current_client) { $client }
  include_examples 'EnclosureUpdateExample', 'integration context'
end
