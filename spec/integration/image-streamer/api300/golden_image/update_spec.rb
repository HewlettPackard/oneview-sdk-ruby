require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::GoldenImage
RSpec.describe klass, integration_i3s: true, type: UPDATE do
  include_context 'integration i3s api300 context'

  describe '#update' do
    it 'updates the name of the golden image' do
      item = klass.find_by($client_i3s_300, name: 'Golden_Image_1').first
      expect(item['uri']).to be
      item['name'] = 'Golden_Image_1_Updated'
      expect { item.update }.not_to raise_error
      item.retrieve!
      expect(item['name']).to eq('Golden_Image_1_Updated')
    end
  end
end
