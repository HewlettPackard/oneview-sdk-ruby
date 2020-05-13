require 'spec_helper'

klass = OneviewSDK::API1600::Synergy::EnclosureGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API1200' do
    expect(described_class).to be < OneviewSDK::API1200::Synergy::EnclosureGroup
  end
end
