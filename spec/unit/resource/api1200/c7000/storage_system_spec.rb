require 'spec_helper'

RSpec.describe OneviewSDK::API1200::C7000::StorageSystem do
  include_context 'shared context'

  let(:client) { @client_1200 }

  it 'inherits from OneviewSDK::API1000::C7000::StorageSystem' do
    expect(described_class).to be < OneviewSDK::API1000::C7000::StorageSystem
  end
end
