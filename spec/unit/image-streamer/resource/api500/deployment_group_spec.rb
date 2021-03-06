require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API500::DeploymentGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API300' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API300::DeploymentGroup
  end
end
