require 'spec_helper'

RSpec.describe OneviewSDK::API1000::C7000::VolumeTemplate do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API800::C7000::VolumeTemplate' do
    expect(described_class).to be < OneviewSDK::API800::C7000::VolumeTemplate
  end
end
