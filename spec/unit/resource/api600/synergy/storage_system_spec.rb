require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::StorageSystem do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::StorageSystem' do
    expect(described_class).to be < OneviewSDK::API500::C7000::StorageSystem
  end
end
