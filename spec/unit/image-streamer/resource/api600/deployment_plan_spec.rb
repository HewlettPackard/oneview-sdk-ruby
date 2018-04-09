require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API600::DeploymentPlan
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API500' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API500::DeploymentPlan
  end

  describe '#get_osdp' do
    it 'raises exception when uri is empty' do
      item = klass.new(@client_i3s_600)
      expect { item.get_osdp }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'returns the response body from uri/osdp/' do
      item = klass.new(@client_i3s_600, uri: '/rest/deployment-plans/fake')
      expect(@client_i3s_600).to receive(:rest_get)
        .with("#{item['uri']}/osdp/", { 'Content-Type' => 'none' }, 600)
        .and_return(FakeResponse.new(response: 'fake'))
      expect(item.get_osdp).to eq('response' => 'fake')
    end
  end
end
