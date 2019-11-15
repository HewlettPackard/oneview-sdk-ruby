require 'spec_helper'

RSpec.describe OneviewSDK::API1000::Synergy::StorageSystem do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1000::C7000::StorageSystem' do
    expect(described_class).to be < OneviewSDK::API1000::C7000::StorageSystem
  end
end
