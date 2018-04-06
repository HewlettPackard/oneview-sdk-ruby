require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API600::OSVolume
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API500' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API500::OSVolume
  end

  describe '#get_os_volumes_storage' do
    it 'raises exception when uri is empty' do
      item = klass.new(@client_i3s_600)
      expect { item.retrieve_read_only }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'returns the response body from uri/storage' do
      item = klass.new(@client_i3s_600, uri: '/rest/os-volumes/fake')
      expect(@client_i3s_600).to receive(:rest_get)
        .with("#{item['uri']}/storage", { 'Content-Type' => 'none' }, 600)
        .and_return(FakeResponse.new(response: 'fake'))
      expect(item.get_os_volumes_storage).to eq('response' => 'fake')
    end
  end
end
