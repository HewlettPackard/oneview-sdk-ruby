require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API1600::PlanScript
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from AP1600' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API1600::PlanScript
  end
end
