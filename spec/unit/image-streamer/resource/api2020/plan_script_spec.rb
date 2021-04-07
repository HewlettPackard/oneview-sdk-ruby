require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API2020::PlanScript
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from AP2010' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API2010::PlanScript
  end
end
