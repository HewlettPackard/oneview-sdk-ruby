require_relative '../../../../spec_helper'

RSpec.describe OneviewSDK::API800::C7000::HypervisorClusterProfile do
  include_context 'shared context'

  it 'inherits from Resource' do
    expect(described_class).to be < OneviewSDK::Resource
  end

  before(:each) do
    @item = OneviewSDK::API800::C7000::HypervisorClusterProfile.new(@client_800, uri: '/rest/fake')
  end

  describe '#initialize' do
    it 'sets the type correctly' do
      expect(@item[:type]).to eq('HypervisorClusterProfileListV3')
    end
  end

  describe '#compliance_preview' do
    it 'Makes a GET call' do
      expect(@client_800).to receive(:rest_get).with(@item['uri'] + '/compliance-preview', {}, @item.api_version)
                                               .and_return(FakeResponse.new({}))
      @item.compliance_preview
    end
  end
end
