require 'spec_helper'

RSpec.describe OneviewSDK::API1600::C7000::Enclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::C7000::Enclosure' do
    expect(described_class).to be < OneviewSDK::API1200::C7000::Enclosure
  end
end
