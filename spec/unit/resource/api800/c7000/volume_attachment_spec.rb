require 'spec_helper'

RSpec.describe OneviewSDK::API800::C7000::VolumeAttachment do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API600::C7000::VolumeAttachment' do
    expect(described_class).to be < OneviewSDK::API600::C7000::VolumeAttachment
  end
end
