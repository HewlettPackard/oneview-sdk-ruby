require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::VolumeAttachment do
  include_context 'shared context'

  it 'inherits from API500 C7000' do
    expect(described_class).to be < OneviewSDK::API500::C7000::VolumeAttachment
  end
end
