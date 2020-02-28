require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API1000::PlanScript
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from AP800' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API800::PlanScript
  end
end
