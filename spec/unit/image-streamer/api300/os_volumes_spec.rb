require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API300::OsVolumes
RSpec.describe klass do
  include_context 'shared context'

  describe '#create' do
    it 'is unavailable' do
      item = klass.new(@client_i3s_300)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#update' do
    it 'is unavailable' do
      item = klass.new(@client_i3s_300)
      expect { item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'is unavailable' do
      item = klass.new(@client_i3s_300)
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end

  describe '#get_details_archive' do
    it 'raises exception when uri is empty' do
      item = klass.new(@client_i3s_300)
      expect { item.get_details_archive }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'gets details of the archive OS Volumes' do
      expect(@client_i3s_300).to receive(:rest_get).with('/rest/os-volumes/archive/fake')
        .and_return(FakeResponse.new(response: 'fake'))
      item = klass.new(@client_i3s_300, uri: '/rest/os-volumes/fake')
      expect(item.get_details_archive).to eq('response' => 'fake')
    end
  end
end
