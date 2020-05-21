require 'spec_helper'

RSpec.describe OneviewSDK::API1200::C7000::VolumeAttachment do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1000::C7000::VolumeAttachment' do
    expect(described_class).to be < OneviewSDK::API1000::C7000::VolumeAttachment
  end
end
