require 'spec_helper'

RSpec.describe OneviewSDK::API800::Synergy::StorageSystem do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API800::C7000::VolumeTemplate' do
    expect(described_class).to be < OneviewSDK::API800::C7000::StorageSystem
  end
end
