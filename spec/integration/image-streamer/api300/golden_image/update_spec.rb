require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::GoldenImage
RSpec.describe klass, integration_i3s: true, type: UPDATE do
  include_context 'integration i3s api300 context'

  describe '#update' do
    it 'updates the name of the golden image' do
    
  end
end
