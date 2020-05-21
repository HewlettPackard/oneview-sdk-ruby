require 'spec_helper'

RSpec.describe OneviewSDK::API1600::Synergy::StoragePool do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1600::C7000::VolumeAttachment' do
    expect(described_class).to be < OneviewSDK::API1600::C7000::StoragePool
  end
end
