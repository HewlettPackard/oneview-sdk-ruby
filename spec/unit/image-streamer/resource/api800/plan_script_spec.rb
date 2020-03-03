require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API800::PlanScript
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from AP600' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API600::PlanScript
  end
end
