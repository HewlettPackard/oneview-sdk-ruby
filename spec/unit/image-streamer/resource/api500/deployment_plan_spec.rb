require 'spec_helper'

klass = OneviewSDK::ImageStreamer::API500::DeploymentPlan
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from API300' do
    expect(described_class).to be < OneviewSDK::ImageStreamer::API300::DeploymentPlan
  end

  describe '#get_used_by' do
    it 'raises exception when uri is empty' do
      item = klass.new(@client_i3s_500)
      expect { item.get_used_by }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri attribute/)
    end

    it 'returns the response body from uri/usedby/' do
      item = klass.new(@client_i3s_500, uri: '/rest/deployment-plans/fake')
      expect(@client_i3s_500).to receive(:rest_get)
        .with("#{item['uri']}/usedby/", { 'Content-Type' => 'none' }, 500)
        .and_return(FakeResponse.new(response: 'fake'))
      expect(item.get_used_by).to eq('response' => 'fake')
    end
  end
end
