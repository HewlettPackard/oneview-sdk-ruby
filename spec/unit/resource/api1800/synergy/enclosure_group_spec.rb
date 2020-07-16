require 'spec_helper'

klass = OneviewSDK::API1800::Synergy::EnclosureGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API1600' do
    expect(described_class).to be < OneviewSDK::API1600::Synergy::EnclosureGroup
  end
end
