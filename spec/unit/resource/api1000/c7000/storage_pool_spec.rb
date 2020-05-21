require 'spec_helper'

RSpec.describe OneviewSDK::API1000::C7000::StoragePool do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API800::C7000::VolumeAttachment' do
    expect(described_class).to be < OneviewSDK::API800::C7000::StoragePool
  end
end
