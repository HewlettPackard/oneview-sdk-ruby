require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::VolumeTemplate do
  include_context 'shared context'

  it 'inherits from API300' do
    expect(described_class).to be < OneviewSDK::API500::C7000::VolumeTemplate
  end
end
